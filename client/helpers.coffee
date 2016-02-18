Template.registerHelper 'appVersion', ->
  return Meteor.settings.public.ghostdoc.version
