Template.viewer.helpers
  render: ->
    if not @text?
      return

    lexData = Tagger.parseToLexical @text
    html = Tagger.renderToHtml lexData, Artifacts.find(texts: @_id)
    return html

Template.viewer.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'
