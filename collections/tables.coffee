TablesCollection = new Mongo.Collection 'tables'

# fields
#   _id
#   levels[]

TablesCollection.helpers
    getContests: ->
        res = []
        for lev in @levels
            cont = Contests.findByLevel(lev).fetch() 
            for c in cont
                res.push(c)
        res
        
Tables =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}
        
    collection: TablesCollection
            
@Tables = Tables
