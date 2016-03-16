Future = Npm.require('fibers/future');

class ContestDownloader
    url: 'http://informatics.mccme.ru/course/view.php?id=1135'
    baseUrl: 'http://informatics.mccme.ru/mod/statements/'

    constructor: ->
        @order = 0
        
    makeProblem: (fullText, href, pid, letter, name) ->
        {
            _id: pid
            letter: letter
            name: name
        }
        
    addContest: (cid, name, level, problems) ->
        @order++
        Contests.addContest(cid, name, @order, level, problems)
        
    processContest: (fullText, href, cid, name, level) ->
        text = syncDownload(href).content
        console.log href, name, level, @url
        re = new RegExp '<a href="(view3.php\\?id=\\d+&amp;chapterid=(\\d+))"><B>Задача ([^.]+)\\.</B> ([^<]+)</a>'
        secondProbRes = re.exec text
        secondProbHref = secondProbRes[1].replace('&amp;','&')
        secondProb = @makeProblem(secondProbRes[0], secondProbRes[1], secondProbRes[2], secondProbRes[3], secondProbRes[4])

        text = syncDownload(@baseUrl + secondProbHref).content
        re = new RegExp '<a href="(view3.php\\?id=\\d+&amp;chapterid=(\\d+))"><B>Задача ([^.]+)\\.</B> ([^<]+)</a>', 'gm'
        problems = []
        text.replace re, (res, a, b, c, d) =>
            console.log "res: ", res
            problems.push(@makeProblem(res, a, b, c, d))
        problems.splice(1, 0, secondProb);
        @addContest(cid, name, level, problems)
        
    run: ->
        text = syncDownload(@url).content
        re = new RegExp '<a title="Условия задач"\\s*href="(http://informatics.mccme.ru/mod/statements/view.php\\?id=(\\d+))">(([^:]*): [^<]*)</a>', 'gm'
        text.replace re, (a,b,c,d,e) => @processContest(a,b,c,d,e)
        
class RegionContestDownloader extends ContestDownloader
    contests: 
        '2009': ['894', '895']
        '2010': ['1540', '1541']
        '2011': ['2748', '2780']
        '2012': ['4345', '4361']
        '2013': ['6667', '6670']
        '2014': ['10372', '10376']
        '2015': ['14482', '14483']
        '2016': ['18805', '18806']
    
    contestBaseUrl: 'http://informatics.mccme.ru/mod/statements/view.php?id='
        
    run: ->
        levels = []
        for year, cont of @contests
            console.log "Downloading contests of ", year, cont
            fullText = ' тур региональной олимпиады ' + year + ' года'
            @processContest('', @contestBaseUrl + cont[0], cont[0], 'Первый' + fullText, 'reg' + year)
            @processContest('', @contestBaseUrl + cont[1], cont[1], 'Второй' + fullText, 'reg' + year)
            levels.push('reg' + year)
        Tables.addTable("reg", levels)
        table = Tables.findById("reg")
        users = Users.findAll().fetch()
        for user in users
            Results.updateResults(user, table)
    
#SyncedCron.add
#    name: 'downloadContests',
#    schedule: (parser) ->
#        return parser.text('every 10 seconds');
##        return parser.text('every 5 minutes');
#    job: -> 
#        (new ContestDownloader()).run()


Meteor.startup ->
#    (new RegionContestDownloader()).run()
#    (new ContestDownloader()).run()
#    Tables.collection.insert({_id: "1a", levels: ["1А", "1Б"]})
#    Tables.collection.insert({_id: "1c", levels: ["1В", "1Г"]})
#    Tables.collection.insert({_id: "2", levels: ["2А", "2Б", "2В"]})
#    Tables.collection.insert({_id: "3", levels: ["3А", "3Б", "3В"]})
#    Tables.collection.insert({_id: "4", levels: ["4А", "4Б", "4В"]})
#    Tables.collection.insert({_id: "5", levels: ["5А", "5Б", "5В"]})    
#    Tables.collection.insert({_id: "6", levels: ["6А", "6Б", "6В"]})