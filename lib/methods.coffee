Meteor.methods
  renderSource: (textId) ->
    check textId, String
    if Meteor.isServer
      @unblock()
      text = Texts.findOne textId
      Ritter.processText text

  renderArtifact: (artifactId) ->
    check artifactId, String
    if Meteor.isServer
      @unblock()
      artifact = Artifacts.findOne artifactId
      Ritter.processArtifact artifact
      Ritter.processGems artifact
