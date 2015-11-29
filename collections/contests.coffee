ContestsCollection = new Mongo.Collection 'contests'

# fields
#   _id
#   problem[]
#   name
#   level

#SubmitsCollection.helpers
#    canRemove: ->
#        if not Users.currentUser()
#            return false
        
Contests =
    findById: (id) ->
        @collection.findOne _id: id

    findByLevel: (level) ->
        @collection.find level: level
        
    findAll: ->
        @collection.find {}
        
    addContest: (id, name, level, problems) ->
        @collection.update({_id: id}, {_id: id, name: name, level: level, problems: problems}, {upsert: true})
        
    collection: ContestsCollection
            
@Contests = Contests
