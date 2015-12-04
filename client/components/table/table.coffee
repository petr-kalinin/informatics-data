Template.table.helpers
    row: ->
        res = Session.get('table')
        res
        
    contests: ->
        @table.getContests()
        
    colspan: ->
        this.problems.length
        
    levelsText: ->
        @table.levels.join(", ")
