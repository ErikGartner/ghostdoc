Meteor.publish 'artifacts', ->
  return Artifacts.find(author: @userId)

Meteor.publish 'texts', ->
  return Texts.find(author: @userId)
