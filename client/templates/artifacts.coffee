Template.artifacts.onRendered ->
  $('#updateArtifactModal').modal
    onHidden: ->
      Session.set 'editArtifactId', undefined

Template.artifacts.helpers
  artifacts: ->
    return Artifacts.find {}, {sort:{name: 1}}

  editId: ->
    return Artifacts.findOne _id: Session.get 'editArtifactId'

Template.artifacts.events
  'click #addArtifact': (event) ->
    $('#insertArtifactModal').modal 'show'
    Session.set 'editArtifactId', undefined

  'click .editArtifact': (event) ->
    id = $(event.target).data 'id'
    Session.set 'editArtifactId', id
    $('#updateArtifactModal').modal 'show'

  'click .selectArtifact': (event) ->
    id = $(event.target).data 'id'
    Session.set 'selectedArtifact', id
    Session.set 'editArtifactId', undefined

AutoForm.addHooks 'addArtifactForm',
  before:
    insert: (doc) ->
      doc.author = Meteor.userId()
      return doc
