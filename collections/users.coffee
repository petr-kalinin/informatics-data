UsersCollection = new Mongo.Collection 'tableUsers'

# fields
#   _id
#   name    
#   userList
#   choco

class FullContestChocoCalculator
    constructor: ->
        @fullContests = 0
        
    processContest: (contest) ->
        full = true
        for tmp,p of contest.problems
            if p.accepted <= 0
                full = false
        if full
            @fullContests++
            
    chocos: ->
        if @fullContests == 0
            0
        else if @fullContests == 1
            1
        else
            (@fullContests // 3) + 1

class CleanContestChocoCalculator
    constructor: ->
        @cleanContests = 0
        
    processContest: (contest) ->
        clean = true
        for tmp,p of contest.problems
            if (p.attempts > 0) or (p.accepted <= 0)
                clean = false
        if clean
            @cleanContests++
            
    chocos: ->
        @cleanContests

class HalfCleanContestChocoCalculator
    constructor: ->
        @hcleanContests = 0
        
    processContest: (contest) ->
        clean = true
        half = true
        for tmp,p of contest.problems
            if (p.attempts > 0) or (p.accepted <= 0)
                clean = false
            if (p.attempts > 1) or (p.accepted <= 0)
                half = false
        if half and (not clean)
            @hcleanContests++
            
    chocos: ->
        @hcleanContests // 2

UsersCollection.helpers
    updateChocos: ->
        results = Results.findByUser(@_id).fetch()
        chocoCalcs = [new FullContestChocoCalculator(), new CleanContestChocoCalculator(), new HalfCleanContestChocoCalculator()]
        for r in results
            for tmp,cont of r.contests
                for calc in chocoCalcs
                    calc.processContest(cont)
        res = []
        for calc in chocoCalcs
            res.push(calc.chocos())
        console.log @name, res
        Users.collection.update({_id: @_id}, {$set: {chocos: res}})
        
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
