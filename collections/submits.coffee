SubmitsCollection = new Mongo.Collection 'submits'

# fields
#   id
#   time
#   user
#   problem
#   outcome

#SubmitsCollection.helpers
#    canRemove: ->
#        if not Users.currentUser()
#            return false
        
Submits =
    findById: (id) ->
        @collection.findOne _id: id
        
    findByUserAndProblem: (user, problem) ->
        @collection.find({user: user, problem: problem})
        
    findAll: ->
        @collection.find {}
        
    collection: SubmitsCollection
            
@Submits = Submits
