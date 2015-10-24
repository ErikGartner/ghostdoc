simplemde = undefined

#*
# Highlights the artifacts
#
postProcessPreivew = (html) ->
  console.log 'Post-processing preview...'
  Artifacts.find().forEach((artifact) ->
    for token in artifact.tokens
      linkStart = '<a class="token" data-id="' + artifact._id + '">'
      linkEnd = '</a>'
      reg = new RegExp('(' + token + ')', 'gi')
      html = html.replace(reg, linkStart + '$1' + linkEnd)
  )
  return html

saveText = ->
  id = Session.get('selectedText')
  text = simplemde.value()

  if id? and text.trim() == ''
    Meteor.call 'deleteText', id
    Session.set('editText', undefined)
    Session.set('selectedText', undefined)
  else
    Meteor.call 'saveText', id, text, (err, res) ->
      if not err?
        Session.set('selectedText', res)
        Session.set('editText', undefined)
  return

Template.editor.onRendered ->
  opts =
    element: $("#simplemde")[0]
    spellChecker: false
    status: ['lines', 'words', 'cursor']
    toolbar: [
      "bold",
      "italic",
      "strikethrough",
      "ordered-list",
      "unordered-list",
      "preview",
      "side-by-side",
      "fullscreen",
      "guide",
      "|",
      {
        name: "save",
        action: saveText,
        className: "fa fa-floppy-o",
        title: "Save",
      }
    ]
    previewRender: (plaintext) ->
      html = marked(plaintext)
      return postProcessPreivew(html)
  simplemde = new SimpleMDE(opts)

  Tracker.autorun ->
    simplemde.value Texts.findOne(_id:Session.get('selectedText'))?.text

Template.editor.events
  'click .token': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedArtifact', id)
