Template.texts.helpers
  texts: ->
    return Texts.find()

Template.texts.events
  'click .textSelector': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedText', id)
    Session.set('selectedArtifact', undefined)

  'click #newText': (event) ->
    Session.set('selectedText', undefined)
    Session.set('selectedArtifact', undefined)
