Meteor.publish 'results', ->
    Results.findAll()