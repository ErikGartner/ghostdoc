@RitterData = new Mongo.Collection('ritterData')

Texts.helpers
  processed: ->
    proc = Ritter.getData @_id, 'text'
    if proc?
      return proc.data
    else
      return marked(@text)

Artifacts.helpers
  processed: ->
    proc = Ritter.getData @_id, 'artifact'
    if proc?
      return proc.data
    else
      return []

  gems: ->
    proc = Ritter.getData @_id, 'gems'
    if proc?
      return proc.data
    else
      return []

projectUpdateHook = (userId, doc) ->
  if Meteor.isServer
    Ritter.processProject doc.project

Texts.after.insert projectUpdateHook
Texts.after.update projectUpdateHook
Texts.after.remove projectUpdateHook

Artifacts.after.insert projectUpdateHook
Artifacts.after.update projectUpdateHook
Artifacts.after.remove projectUpdateHook

Gems.after.insert projectUpdateHook
Gems.after.update projectUpdateHook
Gems.after.remove projectUpdateHook

Projects.after.remove (userId, doc) ->
  if Meteor.isServer
    Ritter.removeProject doc._id
