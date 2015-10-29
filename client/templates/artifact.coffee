Template.artifact.onRendered ->
  $('.ui.sticky').sticky context: '#artifactDiv'

Template.artifact.helpers
  # This helper generates the dynamic list of data
  references: ->
    if not @_id?
      return

    htmls = Tagger.extractReferences Texts.find(_id: $in: @texts), @
    return _.map htmls, (html) ->
      return Tagger.hightlightHTML html, Artifacts.find()

Template.artifact.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'
