Router.route '/table/:userList/:tableId', name: 'tablePage'
class @TablePageController extends ControllerWithTitle
    waitOn: ->
        tableId = this.params.tableId
        userList = this.params.userList
        Meteor.subscribe 'users'
        Meteor.subscribe 'contests'
        Meteor.subscribe 'tables'
        Meteor.subscribe 'resultsForUserListTable', userList, tableId
        Meteor.subscribe 'meteorUser'
        
    data: ->
        tableId = this.params.tableId
        userList = this.params.userList
        return {
            results: Results.findByUserListAndTable(userList, tableId)
            table: Tables.findById tableId
        }
    
    name: ->
        'users'
        
    title: ->
        'Сводная таблица'
