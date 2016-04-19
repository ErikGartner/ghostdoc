Meteor.publishComposite 'projects', ->
  pub =
    find: ->
      user = Meteor.users.findOne _id: @userId
      if user?
        return Projects.find $or: [{author: @userId},
          {collaborators: user.mail()}]
      else
        return undefined

    children: [
      {
        find: (project) ->
          return Texts.find project: project._id
      },
      {
        find: (project) ->
          return Artifacts.find project: project._id
      },
      {
        find: (project) ->
          return Gems.find project: project._id
      },
      {
        find: (project) ->
          return Meteor.users.find {_id: project.author},
            {fields: {'_id': 1, 'profile': 1, 'emails': 1}}
      },
      {
        find: (project) ->
          return RitterData.find({project: project._id})
      }
    ]
  return pub
