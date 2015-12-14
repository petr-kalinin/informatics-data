Template.tableRow.helpers
    name: ->
        user = Users.findById(@result.user)
        user.name

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
        
    solved: ->
        @result.solved
        
    attempts: ->
        @result.attempts
        
    levelTitle: ->
        "Итого по уровню " + @level
        
    solvedInLevel: ->
        res = 0
        for c in Contests.findByLevel(@level).fetch()
            res = res + @result.contests[c._id].solved 
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
    'click .userName': (e,t) ->
        Session.set("activeUser", t.data.result.user)
