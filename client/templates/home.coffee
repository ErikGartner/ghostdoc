Template.home.helpers
  selectedArtifact: ->
    return Session.get('selectedArtifact')

  editText: ->
    return Session.get('editText')
