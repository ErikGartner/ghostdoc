class TaggerClass

  hightlightHTML: (html, artifacts) ->
    artifacts.forEach (artifact) ->
      for token in artifact.tokens
        linkStart = '<a class="token" data-id="' + artifact._id + '">'
        linkEnd = '</a>'
        reg = new RegExp('\\b(' + token + ')', 'gi')
        html = html.replace(reg, linkStart + '$1' + linkEnd)
    return html

  extractReferences: (texts, artifact) ->
    htmls = []
    texts.forEach (textDocument) ->
      text = textDocument.text
      filteredData = []
      data = marked.lexer(text)
      closestsHeader = undefined

      # Filter out elements not containing any token
      for item in data
        if item.type == 'heading'
          closestsHeader = item

        else if item.type == 'paragraph'
          for token in artifact.tokens
            a = S(item.text.toLowerCase()).latinise()
            b = S(token.toLowerCase()).latinise()
            if a.contains(b.s)
              if closestsHeader?
                filteredData.push closestsHeader
                closestsHeader = undefined
              filteredData.push item
              break

      filteredData.links = data.links
      # Convert filtered data to html.
      html = marked.parser(filteredData)
      htmls.push html
    return htmls

@Tagger = new TaggerClass
