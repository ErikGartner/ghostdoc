Template.artifacts.helpers
  artifacts: ->
    return Artifacts.find {}, {sort:{name: 1}}

Template.artifacts.events
  'click .selectArtifact': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'
