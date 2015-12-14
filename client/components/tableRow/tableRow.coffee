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
        
    solvedInLevel: ->
        res = 0
        console.log @level
        for c in Contests.findByLevel(@level).fetch()
            console.log c._id, @result.contests[c._id].solved  
            res = res + @result.contests[c._id].solved 
        res
        
    attemptsInLevel: ->
        res = 0
        for c in Contests.findByLevel(@level).fetch()
            res = res + @result.contests[c._id].attempts 
        res

        
Template.tableRow.events
    'click .userName': (e,t) ->
        Session.set("activeUser", t.data.result.user)
