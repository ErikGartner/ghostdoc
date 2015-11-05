Template.editor.helpers
  editorMode: ->
    if @_id
      return 'update'
    else
      return 'insert'
