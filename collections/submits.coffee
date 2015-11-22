SubmitsCollection = new Mongo.Collection 'submits'

# fields
#   _id
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
        
    problemResult: (user, problem) ->
        submits = @findByUserAndProblem user, problem
        attempts = 0
        success = 0
        submits.forEach (submit) ->
            if submit.outcome == "AC"
                success = 1
            else if success == 0
                attempts++
        {success: success, attempts: attempts}

    displayProblemResult: (user, problem) ->
        res = @problemResult(user, problem)
        result = ""
        if res.success
            result = '+' + (if res.attempts>0 then res.attempts else "")
        else if res.attempts > 0
            result = '-' + res.attempts
        else result = '.'
        result

        
    findAll: ->
        @collection.find {}
        
    collection: SubmitsCollection
            
@Submits = Submits
