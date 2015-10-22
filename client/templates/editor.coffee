#*
# Highlights the artifacts
#
postProcessPreivew = (html) ->
  console.log 'Post-processing preview...'
  Artifacts.find().forEach((artifact) ->
    for token in artifact.tokens
      html = S(html).replaceAll(token, '<a class="token" data-id="' +
                                artifact._id + '">' + token + '</a>').s
  )
  return html

Template.editor.onRendered ->
  opts =
    element: $("#simplemde")[0]
    spellChecker: false
    previewRender: (plaintext) ->
      html = marked(plaintext)
      return postProcessPreivew(html)
  simplemde = new SimpleMDE(opts)

Template.home.events
  'click .token': (event) ->
    console.log 'clicked', $(event.target)
