Template.infobox.helpers

  gemsItems: ->
    if not @_id?
      return
    gems = Texts.find(_id: $in: @texts).map (doc) =>
      GemExtractor.extractGems doc.text, @
    gems = _.flatten gems, true
    return gems
