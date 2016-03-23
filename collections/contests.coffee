ContestsCollection = new Mongo.Collection 'contests'

# fields
#   _id
#   problems[]
#      _id
#      letter
#      name
#   name
#   order
#   level

#SubmitsCollection.helpers
#    canRemove: ->
#        if not Users.currentUser()
#            return false
        
Contests =
    findById: (id) ->
        @collection.findOne _id: id

    findByLevel: (level) ->
        @collection.find({level: level}, {sort: {order: 1}})

    findAll: ->
        @collection.find {}
        
    addContest: (id, name, order, level, problems) ->
        @collection.update({_id: id}, {_id: id, name: name, order: order, level: level, problems: problems}, {upsert: true})
        
    collection: ContestsCollection
            
@Contests = Contests

if Meteor.isServer
    Meteor.startup ->
        Contests.collection._ensureIndex
            order: 1