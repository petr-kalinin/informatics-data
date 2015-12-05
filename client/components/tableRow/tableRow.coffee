Template.tableRow.helpers
    contests: ->
        @table.table.getContests()
        
    name: ->
        user = Users.findById(@row.user)
        console.log user.name
        user.name

    solved: ->
        @row.solved
        
    attempts: ->
        @row.attempts
        
    active: ->
        if Session.get("activeUser") == @row.user
            "active"
        else
            ""
            
Template.tableRow.events
    'click .userName': (e,t) ->
        Session.set("activeUser", t.data.row.user)
