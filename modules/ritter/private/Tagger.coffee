
# Data flow:
# [Markdown] -> (opt.) preprocessMarkdown -> [Markdown] -> parseToLexical ->
# [Lexdata] -> (opt.) extractReferences  -> [Lexdata] -> renderToHtml -> [HTML]
class TaggerClass

  # Regexp for token matching
  @reg = (token) ->
    return new RegExp('\\b(' + token + ')', 'gi')

  @longestFirst = (a, b) ->
    e1 = b?.length
    e2 = a?.length
    return e1>e2 ? 1 : ( e1<e2 ? -1 : 0 )

  # parses markdown to Lexical token
  parseToLexical: (markdown) ->
    return marked.lexer markdown

  # returns a subset of lexdata that contains tokens of artifact
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
            break

    return filteredData

  # Detects and linkifies token
  preprocessMarkdown: (markdown, artifacts) ->
    artifacts.forEach (artifact) ->
      tokens = artifact.tokens.sort(TaggerClass.longestFirst)
      for token in tokens
        link = '(' + artifact._id + ' "GHOSTDOC-TOKEN")'
        markdown = markdown.replace(TaggerClass.reg(token),'[$1]' +
          link)
    return markdown

  # this method just renders without highlighting
  renderToBasicHtml: (lexData) ->
    return marked.parser lexData

  # renders the lexdata to highlighted Ghostdoc html.
  # This method should be called if data has been through preprocessTokens
  renderToHtml: (lexData, projectId, textId) ->
    renderer = new marked.Renderer()

    # save original rendering in case of
    defaultLinkRenderer = renderer.link
    defaultParagraphRender = renderer.paragraph # only adds <p> tags
    defaultHeadingRender = renderer.heading # only adds <p> tags

    # custom rendering function that highlights
    renderer.link = (href, title, text) ->
      if title != 'GHOSTDOC-TOKEN'
        return defaultLinkRenderer(href, title, text)
      else
        href = '/project/' + projectId + '/artifact/' + href
        return '<a class="token" href="' + href + '">' +
          text + '</a>'

    # textId is set then add id of text source to each paragraph
    if textId?
      renderer.paragraph = (text) ->
        return '<p class="reference" data-source="' + textId + '">' +
          text + '</p>'

      renderer.heading = (text, level, raw) ->
        return '<h' + level +
          ' class="reference"' +
          ' data-source="' + textId +
          '" id="header-' +
          raw.toLowerCase().replace(/[^\w]+/g, '-') + '">' + text +
          '</h' + level + '>\n'

    return marked.parser lexData, {renderer: renderer}

@Tagger = new TaggerClass
