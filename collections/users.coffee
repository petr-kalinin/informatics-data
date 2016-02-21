UsersCollection = new Mongo.Collection 'tableUsers'

# fields
#   _id
#   name
#   userList
#   chocos
#   solvedByWeek
#      weekNo: submits

@startDayForWeeks = 
    "lic40": "2015-08-26"
    "zaoch": "2015-08-29"
@MSEC_IN_WEEK = 7 * 24 * 60 * 60 * 1000

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
        
    updateSolvedByWeek: ->
        res = calculateSubmitsByWeek this
        console.log @name, res
        Users.collection.update({_id: @_id}, {$set: {solvedByWeek: res}})
        

Users =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}
        
    findByList: (list) ->
        @collection.find {userList: list}
        
    addUser: (id, name, userList) ->
        @collection.update({_id: id}, {$set: {_id: id, name: name, userList: userList}}, {upsert: true})
            
    collection: UsersCollection

@Users = Users
