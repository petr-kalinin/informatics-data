Meteor.publish 'users', ->
    Users.findAll()