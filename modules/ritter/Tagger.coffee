class RendererClass

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
      html = '<h' + level +
        ' class="reference"' +
        '" id="header-' +
        raw.toLowerCase().replace(/[^A-Za-z0-9_]+/g, '-') + '"'

      if textId?
        html += ' data-source="' + textId

      html += '">' + text +
        '</h' + level + '>\n'
      return html

    return marked.parser lexData, {renderer: renderer}

@RitterRenderer = new RendererClass
