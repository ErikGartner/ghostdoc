Template.toc.helpers
  tableOfContent: ->
    if not @_id? or not @projectId? or not @isProcessed()
      return
    return @analytics().data.toc.data
