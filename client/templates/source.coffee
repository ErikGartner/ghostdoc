Template.source.helpers
  render: ->
    if not @text?
      return

    artifacts = Artifacts.find project: @projectId

    markdown = Tagger.preprocessMarkdown @text, artifacts
    lexData = Tagger.parseToLexical markdown
    html = Tagger.renderToHtml lexData, @projectId
    return html

Template.editSource.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()

Template.source.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'

  'click div': (event) ->
    text = window.getSelection().toString().trim()
    if not text? or text == ''
      return
    console.log text
    $('.ui.popup').popup('show')
