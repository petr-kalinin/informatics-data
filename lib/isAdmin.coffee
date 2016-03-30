@isAdmin = ->
    Meteor.user() and Meteor.user().admin