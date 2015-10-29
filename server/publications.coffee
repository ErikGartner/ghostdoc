Meteor.publish 'artifacts', ->
  return Artifacts.find author: @userId

Meteor.publishComposite 'texts', ->
  pub =
    find: ->
      user = Meteor.users.findOne _id: @userId
      if user?
        return Texts.find $or: [{author: @userId}, {collaborators: user.mail()}]
      else
        return undefined

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
