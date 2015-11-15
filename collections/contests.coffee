ContestsCollection = new Mongo.Collection 'contests'

# fields
#   id
#   problem[]

#SubmitsCollection.helpers
#    canRemove: ->
#        if not Users.currentUser()
#            return false
        
Contests =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}
        
    collection: ContestsCollection
            
@Contests = Contests
