Template.tableRow.helpers
    name: ->
        user = Users.findById(@result.user)
        user.name
        
    userId: ->
        @result.user
        
    active: ->
        if Session.get("activeUser") == @result.user
            "active"
        else
            ""

    contests: ->
        Contests.findByLevel(@level)
        
    levels: ->
        res = []
        for lev in @table.levels
            res.push
                level: lev
                result: @result
        res

    solvedAndOk: ->
        @result.solved + (if @result.ok>0 then "+" + @result.ok else "")

    attempts: ->
        @result.attempts
        
    levelTitle: ->
        "Итого по уровню " + @level
        
    solvedAndOkInLevel: ->
        s = 0
        ok = 0
        for c in Contests.findByLevel(@level).fetch()
            s = s + @result.contests[c._id].solved 
            ok = ok + @result.contests[c._id].ok
        s + (if ok > 0 then "+" + ok else "")
        
    okInLevel: ->
        res = 0
        for c in Contests.findByLevel(@level).fetch()
            res = res + @result.contests[c._id].ok
        res
        
    attemptsInLevel: ->
        res = 0
        for c in Contests.findByLevel(@level).fetch()
            res = res + @result.contests[c._id].attempts 
        res

    totalInLevel: ->
        res = 0
        for c in Contests.findByLevel(@level).fetch()
            res = res + c.problems.length
        res

        
Template.tableRow.events
#    'click .userName': (e,t) ->
#        Session.set("activeUser", t.data.result.user)
        
    'dblclick .userName': (e,t) ->
        url = "http://informatics.mccme.ru/moodle/user/view.php?id=" + t.data.result.user
        window.open(url, '_blank')


