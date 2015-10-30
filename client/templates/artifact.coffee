Template.artifact.onRendered ->
  $('.ui.sticky').sticky context: '#artifactDiv'

Template.artifact.helpers
  # This helper generates the dynamic list of data
  references: ->
    if not @_id?
      return

    return Texts.find(_id: $in: @texts).map (doc) =>
      markdown = Tagger.preprocessMarkdown doc.text,
        Artifacts.find(texts: doc._id)
      lexData = Tagger.parseToLexical markdown
      lexData = Tagger.extractReferences lexData, @
      return Tagger.renderToHtml lexData, doc._id

Template.artifact.events
  'click a.token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'

  'click .reference': (event) ->
    if event.altKey
      text = $(event.target)[0].textContent
      Router.go '/doc/' + $(event.target).data 'source'

      setTimeout( ->
        target = $("*:contains('" + text + "'):last").offset().top - 15
        $('html, body').animate {scrollTop: target}, 'slow'
      , 250)
    return
