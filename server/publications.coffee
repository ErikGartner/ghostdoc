Meteor.publish 'artifacts', ->
  return Artifacts.find()

Meteor.publish 'texts', ->
  return Texts.find()
