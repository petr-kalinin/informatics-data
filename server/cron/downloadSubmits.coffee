Future = Npm.require('fibers/future');

class AllSubmitDownloader
    
    constructor: (@baseUrl, @userList, @minPage, @limitPages) ->
        @addedUsers = {}
    
    AC: 'Зачтено/Принято'
    IG: 'Проигнорировано'
    DQ: 'Дисквалифицировано'
        
    addedUsers: {}
        
    needContinueFromSubmit: (runid) ->
        true

    processSubmit: (uid, name, pid, runid, prob, date, outcome) ->
        #console.log uid, name, pid, runid, prob, date, outcome
        res = @needContinueFromSubmit(runid)
        if (outcome == @AC) 
            outcome = "AC"
        if (outcome == @IG) 
            outcome = "IG"
        if (outcome == @DQ) 
            outcome = "DQ"
        Submits.addSubmit(runid, date, uid, pid, outcome)
        Users.addUser(uid, name, @userList)
        @addedUsers[uid] = uid
        res
    
    parseSubmits: (submitsTable) ->
        submitsRows = submitsTable.split("<tr>")
        result = true
        wasSubmit = false
        for row in submitsRows
            re = new RegExp '<td>[^<]*</td>\\s*<td><a href="/moodle/user/view.php\\?id=(\\d+)">([^<]*)</a></td>\\s*<td><a href="/moodle/mod/statements/view3.php\\?chapterid=(\\d+)&run_id=([0-9r]+)">([^<]*)</a></td>\\s*<td>([^<]*)</td>\\s*<td>[^<]*</td>\\s*<td>([^<]*)</td>', 'gm'
            data = re.exec row
            if not data
                continue
            uid = data[1]
            name = data[2]
            pid = data[3]
            runid = data[4]
            prob = data[5]
            date = data[6]
            outcome = data[7].trim()
            resultSubmit = @processSubmit(uid, name, pid, runid, prob, date, outcome)
            result = result and resultSubmit
            wasSubmit = true
        return result and wasSubmit
    
    run: ->
        console.log "AllSubmitDownloader::run ", @userList, @limitPages
        page = 0
        while true
            submitsUrl = @baseUrl(page)
            submits = syncDownload(submitsUrl)
            submits = submits["data"]["result"]["text"]
            result = @parseSubmits(submits)
            if (page < @minPage) # always load at least minPage pages
                result = true
            if not result
                break
            page = page + 1
            if page > @limitPages
                break
        tables = Tables.findAll().fetch()
        for uid,tmp of @addedUsers
            for t in tables
                Results.updateResults(Users.findById(uid), t)
        for uid,tmp of @addedUsers
            Users.findById(uid).updateChocos()
            Users.findById(uid).updateRatingEtc()
        console.log "Finish AllSubmitDownloader::run ", @userList, @limitPages
            
class LastSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        !Submits.findById(runid)

class UntilIgnoredSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        res = Submits.findById(runid)?.outcome
        r = !((res == "AC") || (res == "IG"))
        return r

    # Лицей 40
lic40url = (page) ->
        'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=3696&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=100&with_comment=&page=' + page + '&action=getHTMLTable'
    # Заоч
zaochUrl = (page) ->
    'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=3644&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=100&with_comment=&page=' + page + '&action=getHTMLTable'

    
SyncedCron.add
    name: 'loadTable-1',
    schedule: (parser) ->
#        return parser.text('every 10 seconds');
        return parser.text('every 1 minutes');
    job: -> 
        (new LastSubmitDownloader(lic40url, 'lic40', 1, 1)).run()
        (new LastSubmitDownloader(zaochUrl, 'zaoch', 1, 1)).run()

SyncedCron.add
    name: 'loadTable-2',
    schedule: (parser) ->
#        return parser.text('every 10 seconds');
        return parser.text('every 5 minutes');
    job: -> 
        (new UntilIgnoredSubmitDownloader(lic40url, 'lic40', 2, 4)).run()
        (new UntilIgnoredSubmitDownloader(zaochUrl, 'zaoch', 2, 4)).run()

SyncedCron.add
    name: 'loadTable-3',
    schedule: (parser) ->
#        return parser.text('every 10 seconds');
        return parser.text('at 0:00');
    job: -> 
        (new AllSubmitDownloader(lic40url, 'lic40', 1, 1e9)).run()
        (new AllSubmitDownloader(zaochUrl, 'zaoch', 1, 1e9)).run()

SyncedCron.start()

Meteor.startup ->
#    (new AllSubmitDownloader(lic40url, 'lic40', 1, 1e9)).run()
#    (new AllSubmitDownloader(zaochUrl, 'zaoch', 1, 1e9)).run()
#    for u in Users.findAll().fetch()
#        u.updateChocos()
#    console.log Submits.problemResult("208403", {_id: "1430"})

#Meteor.startup ->
#    users = Users.findAll().fetch()
#    for user in users
#        user.updateRatingEtc()
#    Results.collection.remove {}
#    tables = Tables.findAll().fetch()
#    users = Users.findAll().fetch()
#    for user in users
#        for t in tables
#            Results.updateResults(user, t)
#        user.updateChocos()
