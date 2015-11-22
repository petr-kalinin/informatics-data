Template.table.helpers
    users: ->
        @users
        
    contests: ->
        @table.getContests()
        
    colspan: ->
        this.problems.length
