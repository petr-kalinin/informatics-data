Meteor.publish 'results', ->
    Results.findAll()
    
Meteor.publish 'resultsForUserListTable', (userList, table)->
    Results.findByUserListAndTable(userList, table)
