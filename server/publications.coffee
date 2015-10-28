Meteor.publishComposite 'texts', ->
  pub =
    find: ->
      user = Meteor.users.findOne _id: @userId
      return Texts.find $or: [{author: @userId}, {collaborators:
        user.services?.facebook?.email}]

    children: [
      {
        find: (text) ->
          return Artifacts.find texts: text._id
      },
      {
        find: (text) ->
          return Meteor.users.find(_id: text.author)
      }
    ]
  return pub
