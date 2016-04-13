Meteor.publish 'submits', ->
    Submits.findAll()

Meteor.publish 'okSubmits', ->
    Submits.findByOutcome("OK")

