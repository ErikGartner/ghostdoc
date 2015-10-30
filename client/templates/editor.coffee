Template.editor.helpers
  editorMode: ->
    console.log @
    if @_id
      return 'update'
    else
      return 'insert'
