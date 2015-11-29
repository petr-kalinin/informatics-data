Template.tableRow.helpers
    contests: ->
        console.log @user.name
        @table.getContests()
        
    name: ->
        console.log @user.name
        @user.name
