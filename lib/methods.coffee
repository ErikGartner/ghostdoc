Meteor.methods

  renderSource: (ritterData, projectId, textId) ->
    check ritterData, Object
    check projectId, String
    check textId, String
    if Meteor.isServer
      lexData = ritterData.data.marked_tree.data
      lexData.links = {}
      compiled = RitterRenderer.renderToHtml lexData, projectId, textId
      RitterData.update {_id: ritterData._id}, {$set: {_compiled: compiled}}
      return compiled

  renderArtifact: (ritterData, projectId, textId) ->
    check ritterData, Object
    check projectId, String
    check textId, String
    if Meteor.isServer
      lexData = ritterData.data.marked_tree.data
      compiled = _.map lexData, (item) ->
        item.tree.links = {}
        return RitterRenderer.renderToHtml item.tree, projectId, item.source
      RitterData.update {_id: ritterData._id}, {$set: {_compiled: compiled}}
      return compiled

  createArtifact: (name, projectId) ->
    check name, String
    check projectId, String
    if name == '' or name.length > 50
      return false

    tokens = name.split ' '
    if Meteor.isServer
      project = Projects.findOne projectId
      if not project? or (project.author != @userId and
                          @userId not in project.collaborators)
        return
      return Artifacts.insert {
        name: name,
        tokens: tokens,
        project: projectId,
        author: @userId
      }
