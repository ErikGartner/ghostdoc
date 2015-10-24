Template.artifact.helpers
  artifact: ->
    return Artifacts.findOne(_id:Session.get('selectedArtifact'))

  # This helper generates the dynamic list of data
  references: ->
    activeArtifact = Artifacts.findOne _id: Session.get('selectedArtifact')
    if not activeArtifact?
      return

    htmls = []
    Texts.find().forEach (textDocument) ->
      text = textDocument.text
      filteredData = []
      data = marked.lexer(text)
      closestsHeader = undefined

      # Filter out elements not containing any token
      for item in data
        if item.type == 'heading'
          closestsHeader = item

        else if item.type == 'paragraph'
          for token in activeArtifact.tokens
            if item.text.toLowerCase().indexOf(token.toLowerCase()) > -1
              if closestsHeader?
                filteredData.push closestsHeader
                closestsHeader = undefined
              filteredData.push item
              break

      filteredData.links = data.links
      html = marked.parser(filteredData)

      # Highlight all containing artifact
      Artifacts.find().forEach((artifact) ->
        for token in artifact.tokens
          html = S(html).replaceAll(token, '<a class="token" data-id="' +
                                    artifact._id + '">' + token + '</a>').s
      )
      htmls.push html
    return htmls

Template.artifact.events
  'click .token': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedArtifact', id)
    return

  'click #artifactLabel': (event) ->
    Session.set('selectedArtifact', undefined)
    return
