Template.viewer.helpers
  render: ->
    text = Texts.findOne(_id: Session.get('selectedText'))?.text
    if not text?
      return

    html = marked(text)
    html = Tagger.hightlightHTML html, Artifacts.find()
    return html

Template.viewer.events
  'click .token': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedArtifact', id)
