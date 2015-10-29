Template.artifact.onRendered ->
  $('.ui.sticky').sticky context: '#artifactDiv'

Template.artifact.helpers
  # This helper generates the dynamic list of data
  references: ->
    if not @_id?
      return

    return Texts.find(_id: $in: @texts).map (doc) =>
      lexData = Tagger.parseToLexical doc.text
      lexData = Tagger.extractReferences lexData, @
      return Tagger.renderToHtml lexData, Artifacts.find(texts: doc._id),
        doc._id

Template.artifact.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'
