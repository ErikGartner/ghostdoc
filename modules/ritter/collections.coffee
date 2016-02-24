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

Texts.after.update (userId, doc, fieldNames, modifier, options) ->
  Ritter.processProject doc.project

Artifacts.after.update (userId, doc, fieldNames, modifier, options) ->
  Ritter.processProject doc.project
