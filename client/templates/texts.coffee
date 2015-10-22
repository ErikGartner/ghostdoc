Template.texts.helpers
  texts: ->
    return Texts.find()

Template.texts.events
  'click .textSelector': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedText', id)
    Session.set('selectedArtifact', undefined)
    Session.set('editText', undefined)

  'click #newText': (event) ->
    Session.set('selectedText', undefined)
    Session.set('selectedArtifact', undefined)
    Session.set('editText', undefined)

  'click .editIcon': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedText', id)
    Session.set('editText', true)
    Session.set('selectedArtifact', undefined)

  'click #newIcon': (event) ->
    Session.set('selectedText', undefined)
    Session.set('editText', true)
    Session.set('selectedArtifact', undefined)
