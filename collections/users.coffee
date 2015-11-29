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
        
    addUser: (id, name, userList) ->
        @collection.update({_id: id}, {_id: id, name: name, userList: userList}, {upsert: true})
            
    collection: UsersCollection

@Users = Users
