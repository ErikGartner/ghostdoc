Meteor.publish 'gems', ->
  return Gems.find author: @userId

Meteor.publish 'artifacts', ->
  return Artifacts.find author: @userId

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
          if not project.sources?
            return undefined
          return Texts.find _id: $in: project.sources
      },
      {
        find: (project) ->
          if not project.artifacts?
            return undefined
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
