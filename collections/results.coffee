ResultsCollection = new Mongo.Collection 'results'

# fields
#   _id
#   user
#   userList
#   table
#   contests
#     problems
#       problem: success, attempts, accepted, submitId, text
#     solved
#     attempts
#   solved
#   attempts

Results =
    findById: (id) ->
        @collection.findOne _id: id
        
    updateResults: (user, table) ->
        console.log "Updating results for ", user.name, table._id
        solved = 0
        attempts = 0
        data =
            _id: user._id + "::" + table._id
            user: user._id
            userList: user.userList
            table: table._id
            contests: {}
        contests = table.getContests()
        wasAttempts = false
        for c in contests
            thisData = 
                problems: {}
            thisSolved = 0
            thisAttempts = 0
            for prob in c.problems
                thisRes = Submits.displayProblemResult(user._id, prob)
                thisData.problems[prob._id] = thisRes
                if thisRes.success > 0
                    thisSolved++
                    thisAttempts += thisRes.attempts
                if (thisRes.success > 0) or (thisRes.attempts > 0)
                    wasAttempts = true
            thisData.solved = thisSolved
            thisData.attempts = thisAttempts
            solved += thisSolved
            attempts += thisAttempts
            data.contests[c._id] = thisData
        data.solved = solved
        data.attempts = attempts
        if (wasAttempts)
            @collection.update({_id: data._id}, data, {upsert: true})
        
    findAll: ->
        @collection.find {}
    
    findByUserListAndTable: (userList, table) ->
        @collection.find {
            userList: userList, 
            table: table
        }, sort: { solved: -1, attempts: 1}
            
        
    collection: ResultsCollection
            
@Results = Results

if Meteor.isServer
    Meteor.startup ->
        Results.collection._ensureIndex
            userList: 1
            table : 1 
            solved: -1
            attempts: 1
