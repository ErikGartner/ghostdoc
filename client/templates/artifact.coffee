Template.artifact.onRendered ->
  $('.ui.sticky').sticky context: '#artifactDiv'

Template.artifact.helpers
  artifact: ->
    return Artifacts.findOne _id:Session.get('selectedArtifact')

  # This helper generates the dynamic list of data
  references: ->
    activeArtifact = Artifacts.findOne _id: Session.get('selectedArtifact')
    if not activeArtifact?
      return
    htmls = Tagger.extractReferences Texts.find(), activeArtifact
    return _.map htmls, (html) ->
      return Tagger.hightlightHTML html, Artifacts.find()

Template.artifact.events
  'click .token': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedArtifact', id)
    return

  'click #artifactLabel': (event) ->
    Session.set('selectedArtifact', undefined)
    return
