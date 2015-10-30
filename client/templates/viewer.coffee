Template.viewer.helpers
  render: ->
    if not @text?
      return

    markdown = Tagger.preprocessMarkdown @text, Artifacts.find(texts: @_id)
    lexData = Tagger.parseToLexical markdown
    html = Tagger.renderToHtml lexData
    return html

Template.viewer.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'
