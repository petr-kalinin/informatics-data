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
    "zaoch": "2015-08-30"
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
        
    updateRatingEtc: ->
        res = calculateRatingEtc this
        console.log @name, res
        Users.collection.update({_id: @_id}, {$set: res})
        
    updateLevel: ->
        res = calculateLevel this
        Users.collection.update({_id: @_id}, {$set: {level: res}})

Users =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}, {sort: {ratingSort: -1}}
        
    findByList: (list) ->
        @collection.find {userList: list}, {sort: {ratingSort: -1}}
        
    addUser: (id, name, userList) ->
        @collection.update({_id: id}, {$set: {_id: id, name: name, userList: userList}}, {upsert: true})
            
    collection: UsersCollection

@Users = Users

if Meteor.isServer
    Meteor.startup ->
        Users.collection._ensureIndex
            userList: 1
            ratingSort: 1
