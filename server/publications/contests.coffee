Meteor.publish 'contests', ->
    Contests.findAll()