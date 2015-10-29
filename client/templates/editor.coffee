simplemde = undefined

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

  simplemde = new SimpleMDE(opts)

  Tracker.autorun ->
    simplemde.value @text

Template.editor.helpers
  editorMode: ->
    console.log @
    if @_id
      return 'update'
    else
      return 'insert'

AutoForm.addHooks 'updateText',
  before:
    insert: (doc) ->
      doc.text = simplemde.value()
      return doc

    update: (doc) ->
      doc.$set.text = simplemde.value()
      return doc
