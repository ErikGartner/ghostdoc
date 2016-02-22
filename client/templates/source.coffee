Template.source.helpers
  render: ->
    if not @text?
      return

    project = Projects.findOne _id: @projectId
    artifacts = Artifacts.find _id: $in: project.artifacts

    markdown = Tagger.preprocessMarkdown @text, artifacts
    lexData = Tagger.parseToLexical markdown
    html = Tagger.renderToHtml lexData, @projectId
    return html

Template.source.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'

  'click div': (event) ->
    text = window.getSelection().toString().trim()
    if not text? or text == ''
      return
    console.log text
    $('.ui.popup').popup('show')
