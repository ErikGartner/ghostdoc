Template.artifactSummary.helpers
  artifact: ->
    return Artifacts.findOne(_id:Session.get('selectedArtifact'))
