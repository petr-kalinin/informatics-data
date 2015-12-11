Router.route '/table/:userList/:tableId', name: 'table'
class @TableController extends ControllerWithTitle
    waitOn: ->
        tableId = this.params.tableId
        userList = this.params.userList
        @subscribe 'users'
        @subscribe 'contests'
        @subscribe 'tables'
        @subscribe 'resultsForUserListTable', userList, tableId
        
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
