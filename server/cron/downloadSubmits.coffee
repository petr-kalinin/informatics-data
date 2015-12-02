Future = Npm.require('fibers/future');

class AllSubmitDownloader
    # Лицей 40
    baseUrl: (page) ->
        'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=3696&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=10&with_comment=&page=' + page + '&action=getHTMLTable'
    # Заоч
    #tableBaseUrl = 'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=3644&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=10&with_comment=&page=%d&action=getHTMLTable'
    
    AC: 'Зачтено/Принято'
    IG: 'Проигнорировано'
        
    needContinueFromSubmit: (runid) ->
        true

    processSubmit: (uid, name, pid, runid, prob, date, outcome, childrenResults) ->
        res = @needContinueFromSubmit(runid)
        if (outcome == @AC) 
            outcome = "AC"
        if (outcome == @IG) 
            outcome = "IG"
        console.log uid, name, pid, runid, prob, date, "'"+outcome+"'"
        Submits.addSubmit(runid, date, uid, pid, outcome)
        Users.addUser(uid, name, "lic40")
        res
    
#    if date > endDate:  # we do not need this, but continue search
#        return True
#    if date < startDate:  # stop search
#        return False
#    #print(name, prob, date, outcome)
#    if not (name in childrenResults.keys()):
#        childrenResults[name] = {}
#    if not (prob in childrenResults[name].keys()):
#        childrenResults[name][prob] = ""
#    if (childrenResults[name][prob] != AC) and (outcome == AC):
#        childrenResults[name][prob] = AC
#    return True

    parseSubmits: (submitsTable, childrenResults) ->
        submitsRows = submitsTable.split("<tr>")
        result = true
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
            resultSubmit = @processSubmit(uid, name, pid, runid, prob, date, outcome, childrenResults)
            result = result and resultSubmit
        return result
    
    run: ->
        childrenResults = {}
        page = 0
        while true
            submitsUrl = @baseUrl(page)
            submits = syncDownload(submitsUrl)
            submits = submits["data"]["result"]["text"]
            result = @parseSubmits(submits, childrenResults)
            if not result
                break
            page = page + 1
        updateResults()
            
class LastSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        !Submits.findById(runid)

class UntilIgnoredSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        res = Submits.findById(runid)?.outcome
        r = !((res == "AC") || (res == "IG"))
        return r
            
            
updateResults = ->
    for user in Users.findAll().fetch()
        for contest in Contests.findAll().fetch()
            if not contest.problems
                continue
            for problem in contest.problems
                if not problem.name
                    continue
                console.log "Updating result", user.name, problem.name
                Results.addResult(user._id, problem._id, Submits.problemResult(user._id, problem))
    
    
SyncedCron.add
    name: 'loadTable',
    schedule: (parser) ->
        return parser.text('every 10 seconds');
#        return parser.text('every 5 minutes');
    job: -> 
        (new UntilIgnoredSubmitDownloader()).run()

SyncedCron.start()
#Meteor.startup ->
#    (new BasicSubmitDownloader()).run()

#Meteor.startup ->
#    updateResults()