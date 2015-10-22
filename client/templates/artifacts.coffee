Template.artifacts.helpers
  artifacts: ->
    return Artifacts.find()

  editId: ->
    return Artifacts.findOne _id: Session.get('editArtifactId')

Template.artifacts.events
  'click #addArtifact': (event) ->
    $('#insertArtifactModal').modal('show')

  'click .editArtifact': (event) ->
    id = $(event.target).data('id')
    Session.set('editArtifactId', id)
    $('#updateArtifactModal').modal('show')

  'click .selectArtifact': (event) ->
    id = $(event.target).data('id')
    Session.set('selectedArtifact', id)

AutoForm.addHooks 'artifactForm',
  before:
    insert: (doc) ->
      doc.author = Meteor.userId()
      return doc
