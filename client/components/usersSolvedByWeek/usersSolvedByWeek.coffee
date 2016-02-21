Template.usersSolvedByWeek.helpers
    users: ->
        Users.findByList("" + this)
