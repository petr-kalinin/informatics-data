Template.table.helpers
    contests: ->
        Contests.findByLevel("" + this)
        
    colspan: ->
        this.problems.length
        
    levelsText: ->
        @table.levels.join(", ")
        
    levels: ->
        @table.levels

    levelTitle: ->
        "Итого по уровню " + this
        

Template.table.events
    'click .topLeft': (e,t) ->
        Session.set("activeUser", undefined)
