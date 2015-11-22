UsersCollection = new Mongo.Collection 'users'

# fields
#   _id
#   name

#UsersCollection.helpers
#    canRemove: ->
#        if not Users.currentUser()
#            return false
        
Users =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}
            
    collection: UsersCollection

@Users = Users
