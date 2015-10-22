#*
# Highlights the artifacts
#
postProcessPreivew = (editor) ->
  console.log 'Post-processing preview...'
  previewer = editor.getElement('previewer').body
  Artifacts.find().forEach((artifact) ->
    for token in artifact.tokens
      $(previewer).html((_, html) ->
        return S(html).replaceAll(token, '<span class="token" data-id="' +
                                  artifact._id + '">' + token + '</span>').s
      )
  )


Template.editor.onRendered ->
  opts =
    autogrow:
      minHeight: 500
    textarea: 'epictextarea'
  epic = Epic.create('epiceditor', opts)
  epic.on('preview', ->
    postProcessPreivew(epic)
  )
  epic.preview()
  $('#epicareaepiceditor').hide()
