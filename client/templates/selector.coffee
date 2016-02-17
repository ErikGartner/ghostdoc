Template.selector_view.onRendered ->
  $('.ui.dropdown').dropdown({
    onChange: (value, text, $selectedItem) ->
      type = $($selectedItem).data('type')
      Router.go type + '.view', {_id: value}
  })

Template.selector_view.helpers
  texts: ->
    return Texts.find()

  artifacts: ->
    return Artifacts.find {}, {sort:{name: 1}}
