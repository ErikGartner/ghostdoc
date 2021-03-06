# Ritter is the main class for processing engine

class RitterClass

  ritterId: (id, type) ->
    return type + '_' + id

  getData: (id, type) ->
    proc = RitterData.findOne id: @ritterId(id, type)

  processProject: (projectId)->
    Texts.find(project: projectId).forEach (text) =>
      @processText text

    Artifacts.find(project: projectId).forEach (artifact) =>
      @processArtifact artifact

    @processProjectAnalytics projectId

  processProjectAnalytics: (projectId) ->
    msg =
      type: 'project_analyzer'
      data:
        id: projectId
    if RabbitMQ.connection?
      RabbitMQ.connection.publish('ghostdoc-ritter', msg, null, null)

  processText: (text) ->
    msg =
      type: 'source_analyzer'
      data:
        id: text._id
    if RabbitMQ.connection?
      RabbitMQ.connection.publish('ghostdoc-ritter', msg, null, null)

  processArtifact: (artifact) ->
    msg =
      type: 'artifact_analyzer'
      data:
        id: artifact._id
    if RabbitMQ.connection?
      RabbitMQ.connection.publish('ghostdoc-ritter', msg, null, null)

  removeProject: (projectId) ->
    RitterData.remove project: projectId

@Ritter = new RitterClass
