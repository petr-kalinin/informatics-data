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

    displayProblemResult: (user, problem) ->
        submits = @collection.find({user: user, problem: problem})
        attempts = 0
        success = 0
        submits.forEach (submit) ->
            if submit.outcome == "AC"
                success = 1
            else if success == 0
                attempts++
        if success
            result = '+' + (if attempts>0 then attempts else "")
        else if attempts > 0
            result = '-' + attempts
        else result = '.'
        result

        
    findAll: ->
        @collection.find {}
        
    collection: SubmitsCollection
            
@Submits = Submits
