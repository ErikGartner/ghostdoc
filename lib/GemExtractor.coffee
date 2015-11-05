# Extracts information from text using regex.

class GemExtractorClass

  # A regex for matching each sentence containing one or more tokens.
  @sentenceReg = (tokens) ->
    reg = '([^.?!]*(?:' + tokens.join('|') + ')[^.?!]*)'
    return RegExp(reg, 'gi')

  # A regex for extracting gem data
  @captureReg = (pattern) ->
    return RegExp(pattern, 'i')

  # Extracts all data related to a gem for one artifcact.
  @extractGem = (text, g, artifact) ->
    results = []
    gem = Gems.findOne _id:g
    if not gem?
      return undefined

    sentenceReg = GemExtractorClass.sentenceReg artifact.tokens

    sentences = text.match sentenceReg
    if not sentences?
      return undefined

    for pattern in gem.patterns
      captureReg = GemExtractorClass.captureReg pattern
      for sentence in sentences
        match = captureReg.exec sentence
        if match?
          results.push match[1]

    if results.length > 0
      return {name: gem.name, result: results}
    else
      return undefined

  # Searches for and extracts all gems
  extractGems: (text, artifact) ->
    gems = []
    if not artifact.gems?
      return gems
    for gem in artifact.gems
      result = GemExtractorClass.extractGem text, gem, artifact
      if result?
        gems.push result
    return gems

@GemExtractor = new GemExtractorClass
