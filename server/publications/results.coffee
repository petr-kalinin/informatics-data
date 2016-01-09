Meteor.publish 'results', ->
    Results.findAll()
    
Meteor.publish 'resultsForUserListTable', (userList, table)->
    Results.findByUserListAndTable(userList, table)

Meteor.publish 'resultsForUser', (user)->
    Results.findByUser(user)
