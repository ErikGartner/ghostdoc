class TaggerClass

  # [Markdown] -> parseToLexical ->[Lexdata] -> (optionally) extractReferences
  #  -> [Lexdata] -> renderToHtml -> [HTML]

  @reg = (token) ->
    return new RegExp('\\b(' + token + ')', 'gi')

  parseToLexical: (markdown) ->
    return marked.lexer markdown

  extractReferences: (lexData, artifact) ->
    filteredData = []
    filteredData.links = lexData.links

    # Filter out elements not containing any token
    closestsHeader = undefined
    for item in lexData
      if item.type == 'heading'
        closestsHeader = item

      else if item.type == 'paragraph'
        for token in artifact.tokens
          if item.text.match(TaggerClass.reg(token))?
            if closestsHeader?
              filteredData.push closestsHeader
              closestsHeader = undefined
            filteredData.push item

    return filteredData

  renderToBasicHtml: (lexData) ->
    # this method just renders without highlighting
    return marked.parser lexData

  renderToHtml: (lexData, artifacts, textId) ->
    renderer = new marked.Renderer()

    # save original rendering in case of
    defaultTextRenderer = renderer.text         # does nothing
    defaultParagraphRender = renderer.paragraph # only adds <p> tags
    defaultHeadingRender = renderer.heading # only adds <p> tags

    # custom rendering function that highlights
    renderer.text = (text) ->
      html = text # skip calling default renderer to speed up
      artifacts.forEach (artifact) ->
        for token in artifact.tokens
          linkStart = '<a href="/artifact/' + artifact._id +
            '"class="token" data-id="' + artifact._id + '">'
          linkEnd = '</a>'
          html = html.replace(TaggerClass.reg(token), linkStart + '$1' +
            linkEnd)
      return html

    console.log renderer.heading

    # textId is set then add id of text source to each paragraph
    if textId?
      renderer.paragraph = (text) ->
        return '<p class="reference" data-source="' + textId + '">' +
          text + '</p>'

      renderer.heading = (text, level, raw) ->
        return '<h' + level +
          ' class="reference"' +
          ' data-source="' + textId +
          '" id="' + this.options.headerPrefix +
          raw.toLowerCase().replace(/[^\w]+/g, '-') + '">' + text +
          '</h' + level + '>\n';

    return marked.parser lexData, {renderer: renderer}

@Tagger = new TaggerClass
