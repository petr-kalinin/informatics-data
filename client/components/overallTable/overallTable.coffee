Template.overallTable.helpers
    users: ->
        Users.findByList("" + this)
