Future = Npm.require('fibers/future');

class ContestDownloader
    url: 'http://informatics.mccme.ru/course/view.php?id=1135'
    baseUrl: 'http://informatics.mccme.ru/mod/statements/'
        
    makeProblem: (fullText, href, pid, letter, name) ->
        {
            _id: pid
            letter: letter
            name: name
        }
        
    addContest: (cid, name, level, problems) ->
        Contests.addContest(cid, name, level, problems)
        
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
        
    
    
#SyncedCron.add
#    name: 'downloadContests',
#    schedule: (parser) ->
#        return parser.text('every 10 seconds');
##        return parser.text('every 5 minutes');
#    job: -> 
#        (new ContestDownloader()).run()


#Meteor.startup ->
#    (new ContestDownloader()).run()