Router.route '/table/:id', name: 'table'
class @TableController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'users'
        @subscribe 'submits'
        @subscribe 'contests'
        @subscribe 'tables'
        
    data: ->
        id = this.params.id
        Tables.findById id
    
    name: ->
        'users'
        
    title: ->
        'Сводная таблица'
        
    users: ->
        Users.findAll()

