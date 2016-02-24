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

  processText: (text) ->
    id = RitterClass.ritterId text._id, 'text'
    RitterData.remove id: id

    artifacts = Artifacts.find project: text.project
    markdown = Tagger.preprocessMarkdown text.text, artifacts
    lexData = Tagger.parseToLexical markdown
    data = Tagger.renderToHtml lexData, text.project

    RitterData.insert {id: id, data: data, type: 'text', project: text.project}

  processArtifact: (doc) ->
    id = RitterClass.ritterId doc._id, 'artifact'
    RitterData.remove id: id

    sources = Texts.find project: doc.project
    artifacts = Artifacts.find project: doc.project

    data = sources.map (text) ->
      markdown = Tagger.preprocessMarkdown text.text, artifacts
      lexData = Tagger.parseToLexical markdown
      lexData = Tagger.extractReferences lexData, doc
      return Tagger.renderToHtml lexData, doc.project, text._id

    RitterData.insert {id: id, data: data, type: 'artifact', project: doc.project}

  processGems: (artifact) ->
    id = RitterClass.ritterId artifact._id, 'gems'
    RitterData.remove id: id

    gems = GemExtractor.extractGems artifact.projectId, artifact._id
    gems = _.flatten gems, true

    RitterData.insert {id: id, data: gems, type: 'gems', project: artifact.project}

  removeProject: (projectId) ->
    RitterData.remove project: projectId

  removeOrphanData: (projectId) ->
    # Remove all data with no source
    return

@Ritter = new RitterClass
