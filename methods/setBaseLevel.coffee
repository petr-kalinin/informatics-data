Meteor.methods
    setBaseLevel: (userId, newLevel) ->
        if (!isAdmin())
            throw new Meteor.error('Not authorized')
        user = Users.findById(userId)
        user.setBaseLevel(newLevel)