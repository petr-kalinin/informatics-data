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
        @collection.find({user: user, problem: problem._id}, {sort: {time: 1}})
        
    problemResult: (user, problem) ->
        submits = @findByUserAndProblem user, problem
        attempts = 0
        success = 0
        accepted = 0
        lastId = undefined
        submits.forEach (submit) ->
            if accepted <= 0
                lastId = submit._id
                if submit.outcome == "IG"
                    accepted = -1
                    success = -1
                else if submit.outcome == "AC"
                    success = 1
                    accepted = 1
                else if submit.outcome == "OK"
                    success = 1
                    accepted = 0
                else 
                    attempts++
        {success: success, attempts: attempts, accepted: accepted, submitId: lastId}

    displayProblemResult: (user, problem) ->
        res = @problemResult(user, problem)
        result = ""
        if res.success > 0
            result = '+' + (if res.attempts>0 then res.attempts else "")
        else if res.attempts > 0
            result = '-' + res.attempts
        else result = '.'
        res["text"] = result
        res
        
    addSubmit: (id, time, user, problem, outcome) ->
        @collection.update({_id: id}, {_id: id, time: time, user: user, problem: problem, outcome: outcome}, {upsert: true})
#   _id
#   time
#   user
#   problem
#   outcome

        
    findAll: ->
        @collection.find {}
        
    collection: SubmitsCollection
            
@Submits = Submits

if Meteor.isServer
    Meteor.startup ->
        Submits.collection._ensureIndex({ "problem": 1, "user" : 1, time: 1});