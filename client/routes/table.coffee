Router.route '/table/', name: 'table'
class @TableController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'users'
        @subscribe 'submits'
        @subscribe 'contests'
        
    data: ->
        Users.findAll
    
    name: ->
        'users'
        
    title: ->
        'Сводная таблица'
        
    users: ->
        Users.findAll()

