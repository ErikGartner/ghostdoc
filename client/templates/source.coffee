Template.source.helpers
  render: ->
    if not @text?
      return
    return @processed()

Template.editSource.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()

Template.source.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'

  'mouseup .reference': (event) ->
    if event.altKey
      $(event.target).popup
        popup: '#addArtifactPopup'
        on: 'manual'
        position: 'top left'
      $(event.target).popup 'show'

  'click #addArtifactButton': (event) ->
    text = window.getSelection().toString().trim()
    if not text? or text == ''
      return
    Meteor.call 'createArtifact', text, @project
