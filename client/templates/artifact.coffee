Template.artifact.helpers
  # This helper generates the dynamic list of data
  references: ->
    if not @_id?
      return

    project = Projects.findOne(_id: @projectId)
    sources = Texts.find(_id: $in: project.sources)
    artifacts = Artifacts.find(_id: $in: project.artifacts)

    return sources.map (doc) =>
      markdown = Tagger.preprocessMarkdown doc.text, artifacts
      lexData = Tagger.parseToLexical markdown
      lexData = Tagger.extractReferences lexData, @
      return Tagger.renderToHtml lexData, @projectId, doc._id

Template.artifact.events
  'click a.token': (event) ->
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
