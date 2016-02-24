Template.user.helpers
    tables: ->
        tables = Tables.findAll().fetch()
        res = []
        for t in tables
            thisRes = Results.findByUserAndTable(@_id, t._id).fetch()
            if thisRes.length > 0
                res.push
                    table: t
                    results: thisRes
        res
        
    activity: ->
        @activity.toFixed(2)
        
    choco: ->
        @choco
        
    lic40: ->
        @userList == "lic40"
        
        
