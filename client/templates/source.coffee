Template.source.helpers
  render: ->
    if not @text?
      return
    return @processed()

Template.editSource.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()

Template.source.events
  'click .token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'
