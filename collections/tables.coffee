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
        @collection.find({}, {sort: {_id: 1}})
        
    addTable: (id, levels) ->
        @collection.update({_id: id}, {_id: id, levels: levels}, {upsert: true})
        
    collection: TablesCollection
            
@Tables = Tables
