Template.table.helpers
    users: ->
        Users.findAll()
        
    contests: ->
        @getContests()
        
    colspan: ->
        this.problems.length
