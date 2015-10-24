Template.viewer.helpers
  render: ->
    text = Texts.findOne(_id: Session.get('selectedText'))?.text
    if not text?
      return

    html = marked(text)
    Artifacts.find().forEach((artifact) ->
      for token in artifact.tokens
        linkStart = '<a class="token" data-id="' + artifact._id + '">'
        linkEnd = '</a>'
        reg = new RegExp('(' + token + ' )', 'gi')
        html = html.replace(reg, linkStart + '$1' + linkEnd)
    )
    return html

Template.viewer.events
  'click .token': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedArtifact', id)
