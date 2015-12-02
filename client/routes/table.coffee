Router.route '/table/:userList/:tableId', name: 'table'
class @TableController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'users'
        @subscribe 'contests'
        @subscribe 'tables'
        
    data: ->
        Session.set("table", [])
        tableId = this.params.tableId
        userList = this.params.userList
        Meteor.call 'makeTable', tableId, userList, (error, response) ->
            Session.set("table", response)
        res = 
            table: Tables.findById tableId
            users: Users.findByList userList
        res
        
    
    name: ->
        'users'
        
    title: ->
        'Сводная таблица'
        
    users: ->
        Users.findAll()

