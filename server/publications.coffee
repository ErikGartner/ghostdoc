# Gives all projects and the names of top 10 sources/artifacts
Meteor.publishComposite 'list.projects', ->
  find: ->
    user = Meteor.users.findOne _id: @userId
    if user?
      return Projects.find {$or: [{author: @userId},
        {collaborators: user.mail()}]}, {fields: {'trello_user_key': 0}}
    else
      return @ready()

  children: [
    {
      find: (project) ->
        return Texts.find {project: project._id},
          {fields: {_id: 1, name: 1, project: 1}, limit: 10, sort: ['name']}
    },
    {
      find: (project) ->
        return Artifacts.find {project: project._id},
          {fields: {_id: 1, name: 1, project: 1}, limit: 10, sort: ['name']}
    },
    {
      find: (project) ->
        return Gems.find {project: project._id},
          {fields: {_id: 1, name: 1, project: 1}, limit: 10, sort: ['name']}
    },
    {
      find: (project) ->
        return Meteor.users.find {_id: project.author},
          {fields: {'_id': 1, 'profile': 1, 'emails': 1}}
    }
  ]

# Get all data associated with a project
Meteor.publishComposite 'get.project', (id) ->
  find: ->
    user = Meteor.users.findOne _id: @userId
    if user?
      return Projects.find {$and: [{$or: [{author: @userId},
        {collaborators: user.mail()}]}, _id: id]},
        {fields: {'trello_user_key': 0}}
    else
      return @ready()

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
        return RitterData.find({project: project._id})
    }
  ]
