# Ritter is the main class for processing engine

class RitterClass

  @ritterId: (id, type) ->
    return type + '_' + id

  getData: (id, type) ->
    proc = RitterData.findOne id: RitterClass.ritterId(id, type)

  processProject: (projectId)->
    @removeOrphanData projectId

    Texts.find(project: projectId).forEach (text) =>
      @processText text

    Artifacts.find(project: projectId).forEach (artifact) =>
      @processArtifact artifact
      @processGems artifact

  processText: (text, force) ->
    id = RitterClass.ritterId text._id, 'text'
    if not force and RitterData.findOne(id: id)?
      return

    RitterData.remove id: id

    @runExternalSourceAnalyzer text

    artifacts = Artifacts.find project: text.project
    markdown = Tagger.preprocessMarkdown text.text, artifacts
    lexData = Tagger.parseToLexical markdown
    @processTOC text._id, 'text', text.project, lexData
    data = Tagger.renderToHtml lexData, text.project

    RitterData.insert {id: id, data: data, type: 'text', project: text.project}

  processTOC: (docId, type, project, lexData) ->
    id = RitterClass.ritterId docId, type + '-toc'
    RitterData.remove id: id

    toc = Tagger.generateTOC lexData

    RitterData.insert {id: id, data: toc, type: 'toc', project: project}

  processArtifact: (doc, force) ->
    id = RitterClass.ritterId doc._id, 'artifact'
    if not force and RitterData.findOne(id: id)?
      return

    RitterData.remove id: id

    @runExternalArtifactAnalyzer doc

    sources = Texts.find project: doc.project
    artifacts = Artifacts.find project: doc.project

    allLexData = []
    data = sources.map (text) ->
      markdown = Tagger.preprocessMarkdown text.text, artifacts
      lexData = Tagger.parseToLexical markdown
      lexData = Tagger.extractReferences lexData, doc
      allLexData = allLexData.concat lexData
      return Tagger.renderToHtml lexData, doc.project, text._id

    @processTOC doc._id, 'artifact', doc.project, allLexData

    RitterData.insert {id: id, data: data, type: 'artifact', project: doc.project}

  processGems: (artifact) ->
    id = RitterClass.ritterId artifact._id, 'gems'
    RitterData.remove id: id

    gems = GemExtractor.extractGems artifact.project, artifact._id
    gems = _.flatten gems, true

    RitterData.insert {id: id, data: gems, type: 'gems', project: artifact.project}

  runExternalArtifactAnalyzer: (artifact) ->
    msg =
      type: 'artifact_analyzer'
      data:
        id: artifact._id
    if RabbitMQ.connection?
      RabbitMQ.connection.publish('ghostdoc-ritter', msg, null, null)

  runExternalSourceAnalyzer: (text) ->
    msg =
      type: 'source_analyzer'
      data:
        id: text._id
    if RabbitMQ.connection?
      RabbitMQ.connection.publish('ghostdoc-ritter', msg, null, null)

  removeProject: (projectId) ->
    RitterData.remove project: projectId

  removeOrphanData: (projectId) ->
    RitterData.remove project: projectId
    return

@Ritter = new RitterClass
