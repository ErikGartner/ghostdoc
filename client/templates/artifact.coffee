Template.artifact.helpers
  # This helper generates the dynamic list of data
  references: ->
    if not @_id?
      return

    projectId = Router.current().params._projectId
    project = Projects.findOne(_id: projectId)
    sources = Texts.find(_id: $in: project.sources)
    artifacts = Artifacts.find(_id: $in: project.artifacts)

    return sources.map (doc) =>
      markdown = Tagger.preprocessMarkdown doc.text, artifacts
      lexData = Tagger.parseToLexical markdown
      lexData = Tagger.extractReferences lexData, @
      return Tagger.renderToHtml lexData, doc._id

  projectId: ->
    return Router.current().params._projectId

Template.artifact.events
  'click a.token': (event) ->
    currentId = Router.current().params._id
    id = $(event.target).data('id')
    if id == currentId
      return
    projectId = Router.current().params._projectId
    Router.go 'artifact.view', {_projectId: projectId, _id: id}
    $('html, body').animate {scrollTop: 0}, 'slow'

  'click .reference': (event) ->
    if event.altKey
      text = $(event.target)[0].textContent
      id = $(event.target).data 'source'
      projectId = Router.current().params._projectId
      Router.go 'doc.view', {_projectId: projectId, _id: id}

      setTimeout( ->
        target = $("*:contains('" + text + "'):last").offset().top - 15
        $('html, body').animate {scrollTop: target}, 'slow'
      , 250)
    return
