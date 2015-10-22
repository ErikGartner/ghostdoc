Template.viewer.helpers
  render: ->
    text = Texts.findOne(_id: Session.get('selectedText'))?.text
    if not text?
      return

    html = marked(text)
    Artifacts.find().forEach((artifact) ->
      for token in artifact.tokens
        html = S(html).replaceAll(token, '<a class="token" data-id="' +
                                  artifact._id + '">' + token + '</a>').s
    )
    return html

Template.viewer.events
  'click .token': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedArtifact', id)
