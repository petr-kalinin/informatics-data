TablesCollection = new Mongo.Collection 'tables'

# fields
#   _id
#   contests[]

TablesCollection.helpers
    getContests: ->
        Contests.findById(c) for c in @contests
        
Tables =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}
        
    collection: TablesCollection
            
@Tables = Tables
