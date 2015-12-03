Meteor.methods
    makeTable: (tableId, userListId) ->
        users = Users.findByList(userListId).fetch()
        table = Tables.findById(tableId)
        contests = table.getContests()
        res = []
        for user in users
            outcomes = {}
            solved = 0
            attempts = 0
            for c in contests
                for prob in c.problems
                    thisRes = Results.display(user._id, prob)
                    outcomes[prob._id] = thisRes
                    attempts += thisRes.attempts
                    if thisRes.success > 0
                        solved++
            res.push
                user: user._id
                outcomes: outcomes
                solved: solved
                attempts: attempts
        res.sort (a,b) ->
            if a.solved != b.solved
                return b.solved - a.solved
            return a.attempts - b.attempts
        return res
            
    date: ->
        console.log (new Date()).toString()
        return (new Date()).toString()