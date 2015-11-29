Router.route '/table/:userList/:tableId', name: 'table'
class @TableController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'users'
        @subscribe 'submits'
        @subscribe 'contests'
        @subscribe 'tables'
        @subscribe 'results'
        
    data: ->
        tableId = this.params.tableId
        userList = this.params.userList
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

