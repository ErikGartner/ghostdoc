showModal = (event) ->
  if event.altKey
    $('#addArtifactModal').modal 'show'

updateSelectedText = (event) ->
  Session.set 'selectedText', window.getSelection().toString().trim()

hideModal = (event) ->
  $('#addArtifactModal').modal 'hide'

Template.inlineAddArtifact.helpers
  selectedValues: ->
    return {
      name: Session.get 'selectedText'
      tokens: Session.get('selectedText')?.
        replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&").split(' ')
    }

Template.inlineAddArtifact.onRendered ->
  $('body').on 'keyup', showModal
  $('body').on 'mouseup', updateSelectedText
  $('body').on 'click #addArtifactButton', hideModal

Template.inlineAddArtifact.onDestroyed ->
  $('body').off 'keyup', showModal
  $('body').off 'mouseup', updateSelectedText
  $('body').off 'click #addArtifactButton', hideModal
