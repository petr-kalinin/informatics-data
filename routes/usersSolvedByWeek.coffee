Router.route '/usersSolvedByWeek/:userList', name: 'usersSolvedByWeek'
class @UsersSolvedByWeekController extends ControllerWithTitle
    waitOn: ->
        userList = this.params.userList
        Meteor.subscribe 'users'
        Meteor.subscribe 'meteorUser'
        
    data: ->
        userList = this.params.userList
        return userList
    
    name: ->
        'users'
        
    title: ->
        'Посылки по неделям'
