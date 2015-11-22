Meteor.publish 'tables', ->
    Tables.findAll()