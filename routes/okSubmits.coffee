Router.route '/okSubmits', name: 'okSubmits'
class @OkSubmitsController extends ControllerWithTitle
    waitOn: ->
        Meteor.subscribe 'okSubmits'
        Meteor.subscribe 'users'
        Meteor.subscribe 'meteorUser'
        Meteor.subscribe 'contests'
        
    data: ->
        return
    
    name: ->
        'okSubmits'
        
    title: ->
        'OK-посылки'
