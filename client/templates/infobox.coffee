Template.infobox.helpers
  gemsItems: ->
    if not @_id? or not @projectId?
      return
    console.log(@externalAnalytics())
    return @gems()
