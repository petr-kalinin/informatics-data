Template.table.helpers
    contests: ->
        @table.getContests()
        
    colspan: ->
        this.problems.length
        
    levelsText: ->
        @table.levels.join(", ")

Template.table.events
    'click .topLeft': (e,t) ->
        Session.set("activeUser", undefined)
