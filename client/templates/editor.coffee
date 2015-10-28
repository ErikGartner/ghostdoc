simplemde = undefined

#*
# Highlights the artifacts
#
postProcessPreivew = (html) ->
  console.log 'Post-processing preview...'
  return Tagger.hightlightHTML html, Artifacts.find()

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
      "guide"
    ]
    previewRender: (plaintext) ->
      html = marked(plaintext)
      return postProcessPreivew(html)
  simplemde = new SimpleMDE(opts)

  Tracker.autorun ->
    simplemde.value Texts.findOne(_id:Session.get('selectedText'))?.text

Template.editor.helpers
  editorMode: ->
    if Session.get 'selectedText'
      return 'update'
    else
      return 'insert'

  editDoc: ->
    return Texts.findOne(_id:Session.get('selectedText'))

AutoForm.addHooks 'updateText',
  before:
    insert: (doc) ->
      doc.text = simplemde.value()
      return doc

    update: (doc) ->
      doc.$set.text = simplemde.value()
      return doc
