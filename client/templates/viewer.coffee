Template.viewer.helpers
  render: ->
    if not @text?
      return

    html = marked(@text)
    html = Tagger.hightlightHTML html, Artifacts.find(texts: @_id)
    return html

Template.viewer.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'
