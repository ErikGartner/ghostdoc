Template.artifact.helpers
  # This helper generates the dynamic list of data
  references: ->
    if not @_id?
      return
    return @processed()

Template.editArtifact.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()

Template.artifact.events
  'click a.token': (event) ->
    $('html, body').animate {scrollTop: 0}, 'slow'

  'click .reference': (event) ->
    if event.altKey
      text = $(event.target)[0].textContent
      id = $(event.target).data 'source'
      projectId = Router.current().params._projectId
      Router.go 'source.view', {_projectId: projectId, _id: id}

      setTimeout( ->
        target = $("*:contains('" + text + "'):last").offset().top - 15
        $('html, body').animate {scrollTop: target}, 'slow'
      , 250)
    return
