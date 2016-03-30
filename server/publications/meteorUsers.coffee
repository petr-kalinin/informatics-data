Meteor.publish "meteorUser", ->
    Meteor.users.find({_id: this.userId}, {fields: {'admin': 1}})