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
        @table.getContests()
        
    solved: ->
        @result.solved
        
    attempts: ->
        @result.attempts
        
Template.tableRow.events
    'click .userName': (e,t) ->
        Session.set("activeUser", t.data.result.user)
