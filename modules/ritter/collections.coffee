@RitterData = new Mongo.Collection('ritterData')

Texts.helpers
  processed: ->
    proc = Ritter.getData @_id, 'source_analytics'
    if proc?
      if not proc._compiled?
        Meteor.call 'renderSource', proc, @project, @_id
        return false
      else
        return proc._compiled

  isProcessed: ->
    return Ritter.getData(@_id, 'source_analytics')?

  analytics: ->
    return Ritter.getData @_id, 'source_analytics'

Artifacts.helpers
  processed: ->
    proc = Ritter.getData @_id, 'artifact_analytics'
    if proc?
      if not proc._compiled?
        Meteor.call 'renderArtifact', proc, @project, @_id
        return false
      else
        return proc._compiled

  isProcessed: ->
    return Ritter.getData(@_id, 'artifact_analytics')?

  analytics: ->
    return Ritter.getData @_id, 'artifact_analytics'

projectUpdateHook = (userId, doc) ->
  if Meteor.isServer
    Ritter.processProject doc.project

Texts.after.insert projectUpdateHook
Texts.after.update projectUpdateHook
Texts.after.remove (userId, doc) ->
  if Meteor.isServer
    id = Ritter.ritterId doc._id, 'source_analytics'
    RitterData.remove {id: id}
    Ritter.processProject doc.project

Artifacts.after.insert projectUpdateHook
Artifacts.after.update projectUpdateHook
Artifacts.after.remove (userId, doc) ->
  if Meteor.isServer
    id = Ritter.ritterId doc._id, 'artifact_analytics'
    RitterData.remove {id: id}
    Ritter.processProject doc.project

Gems.after.insert projectUpdateHook
Gems.after.update projectUpdateHook
Gems.after.remove projectUpdateHook

Projects.after.remove (userId, doc) ->
  if Meteor.isServer
    Ritter.removeProject doc._id
