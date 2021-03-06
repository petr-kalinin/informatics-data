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
#     ok
#     attempts
#   solved
#   ok 
#   attempts

Results =
    findById: (id) ->
        @collection.findOne _id: id
        
    updateResults: (user, table) ->
        console.log "Updating results for ", user.name, table._id
        solved = 0
        ok = 0
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
            thisOk = 0
            thisAttempts = 0
            for prob in c.problems
                thisRes = Submits.displayProblemResult(user._id, prob)
                thisData.problems[prob._id] = thisRes
                if thisRes.accepted > 0
                    thisSolved++
                    thisAttempts += thisRes.attempts
                if (thisRes.accepted == 0) && (thisRes.success > 0)
                    thisOk++
                    thisAttempts += thisRes.attempts
                if (thisRes.success > 0) or (thisRes.attempts > 0) or (thisRes.accepted == Submits.DQconst)
                    wasAttempts = true
            thisData.solved = thisSolved
            thisData.ok = thisOk
            thisData.attempts = thisAttempts
            solved += thisSolved
            ok += thisOk
            attempts += thisAttempts
            data.contests[c._id] = thisData
        data.solved = solved
        data.ok = ok
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
            
    findByUser: (userId) ->
        @collection.find {
            user: userId, 
        }

    findByUserAndTable: (userId, tableId) ->
        @collection.find {
            user: userId, 
            table: tableId
        }
        
    collection: ResultsCollection
            
@Results = Results

if Meteor.isServer
    Meteor.startup ->
        Results.collection._ensureIndex
            userList: 1
            table : 1 
            solved: -1
            attempts: 1

        Results.collection._ensureIndex
            user: 1
            table: 1
