UsersCollection = new Mongo.Collection 'users'

# fields
#   _id
#   name
#   userList

#UsersCollection.helpers
#    canRemove: ->
#        if not Users.currentUser()
#            return false
        
Users =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}
        
    findByList: (list) ->
        @collection.find {userList: list}
            
    collection: UsersCollection

@Users = Users
