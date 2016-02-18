Template.viewer.helpers
  render: ->
    if not @text?
      return

    markdown = Tagger.preprocessMarkdown @text, Artifacts.find(texts: @_id)
    lexData = Tagger.parseToLexical markdown
    html = Tagger.renderToHtml lexData
    return html

  projectId: ->
    return Router.current().params._projectId

Template.viewer.events
  'click .token': (event) ->
    id = $(event.target).data('id')
    projectId = Router.current().params._projectId
    Router.go 'artifact.view', {_projectId: projectId, _id: id}
    $('html, body').animate {scrollTop: 0}, 'slow'

  'click div': (event) ->
    text = window.getSelection().toString().trim()
    if not text? or text == ''
      return
    console.log text
    $('.ui.popup').popup('show')
