Template.overallHeader.helpers
    contests: ->
        Contests.findByLevel("" + this)
        
    tables: ->
        Tables.findAll()
        
