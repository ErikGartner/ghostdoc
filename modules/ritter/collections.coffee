@RitterData = new Mongo.Collection('ritterData')

Texts.helpers
  processed: ->
    proc = Ritter.getData @_id, 'text'
    if proc?
      return proc.data
    else
      Meteor.call 'renderSource', @_id
      return marked(@text)

  isProcessed: ->
    return Ritter.getData(@_id, 'text')?

  tableOfContent: ->
    proc = Ritter.getData @_id, 'text-toc'
    if proc?
      return proc.data
    else
      return false

Artifacts.helpers
  processed: ->
    proc = Ritter.getData @_id, 'artifact'
    if proc?
      return proc.data
    else
      Meteor.call 'renderArtifact', @_id
      return false

  gems: ->
    proc = Ritter.getData @_id, 'gems'
    if proc?
      return proc.data
    else
      return false

  externalAnalytics: ->
    proc = Ritter.getData @_id, 'artifact_analytics'
    if proc?
      return proc.data
    else
      return false

  tableOfContent: ->
    proc = Ritter.getData @_id, 'artifact-toc'
    if proc?
      return proc.data
    else
      return false

projectUpdateHook = (userId, doc) ->
  if Meteor.isServer
    Ritter.removeProject doc.project

Texts.after.insert projectUpdateHook
Texts.after.update projectUpdateHook
Texts.after.remove projectUpdateHook

Artifacts.after.insert projectUpdateHook
Artifacts.after.update projectUpdateHook
Artifacts.after.remove projectUpdateHook

Gems.after.insert projectUpdateHook
Gems.after.update projectUpdateHook
Gems.after.remove projectUpdateHook

Projects.after.remove projectUpdateHook
