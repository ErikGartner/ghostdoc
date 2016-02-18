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
          return Texts.find _id: $in: project.sources
      },
      {
        find: (project) ->
          return Artifacts.find _id: $in: project.artifacts
      },
      {
        find: (project) ->
          if not project.gems?
            return undefined
          return Gems.find _id: $in: project.gems
      },
      {
        find: (project) ->
          return Meteor.users.find(_id: project.author)
      }
    ]
  return pub
