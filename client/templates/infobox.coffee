Template.infobox.helpers

  gemsItems: ->
    if not @_id?
      return
    gems = Texts.find(_id: $in: @texts).map (doc) =>
      GemExtractor.extractGems doc.text, @
    console.log gems
    gems = _.flatten gems, true
    console.log gems
    return gems
