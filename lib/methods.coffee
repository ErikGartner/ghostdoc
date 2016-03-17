Meteor.methods
  renderSource: (textId) ->
    check textId, String
    if Meteor.isServer
      text = Texts.findOne textId
      if text?
        Ritter.processText text

  renderArtifact: (artifactId) ->
    check artifactId, String
    if Meteor.isServer
      artifact = Artifacts.findOne artifactId
      if artifact?
        Ritter.processArtifact artifact
        Ritter.processGems artifact
