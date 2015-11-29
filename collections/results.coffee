ResultsCollection = new Mongo.Collection 'results'

# fields
#   _id
#   user
#   problem
#   result
#      success, attempts, accepted

Results =
    findById: (id) ->
        @collection.findOne _id: id
        
    findByUserAndProblem: (user, problem) ->
        @collection.findOne({_id: user + "::" + problem._id}).result
        
    display: (user, problem) ->
        res = @findByUserAndProblem(user, problem)
        result = ""
        if res.success > 0
            result = '+' + (if res.attempts>0 then res.attempts else "")
        else if res.attempts > 0
            result = '-' + res.attempts
        else result = '.'
        res["text"] = result
        res
        
    addResult: (user, problem, result) ->
        id = user + "::" + problem
        @collection.update({_id: id}, {_id: id, user: user, problem: problem, result: result}, {upsert: true})
        
    findAll: ->
        @collection.find {}
        
    collection: ResultsCollection
            
@Results = Results

if Meteor.isServer
    Meteor.startup ->
        Submits.collection._ensureIndex({ "problem": 1, "user" : 1, time: 1});