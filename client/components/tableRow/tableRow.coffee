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