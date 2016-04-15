Template.infobox.helpers
  gemsItems: ->
    if not @_id? or not @projectId? or not @isProcessed()
      return
    return @analytics().data.gems.data
