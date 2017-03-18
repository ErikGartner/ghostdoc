showModal = (event) ->
  if event.altKey
    $('#addArtifactModal').modal 'show'
    return false
  return true

updateSelectedText = (event) ->
  if $(event.target).hasClass('reference')
    Session.set 'selectedText', window.getSelection().toString().trim()
    return false
  return true

hideModal = (event) ->
  if $(event.target).attr('id') == 'addArtifactButton'
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
  $('#addArtifactModal').on 'click', hideModal

Template.inlineAddArtifact.onDestroyed ->
  $('body').off 'keyup', showModal
  $('body').off 'mouseup', updateSelectedText
  $('#addArtifactModal').off 'click', hideModal
