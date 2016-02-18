Template.infobox.helpers

  gemsItems: ->
    projectId = Router.current().params._projectId
    if not @_id or not projectId?
      return

    gems = GemExtractor.extractGems projectId, @_id
    console.log gems
    return gems
