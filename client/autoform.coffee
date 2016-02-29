addToProjectHook =
  before:
    insert: (doc) ->
      doc.project = Router.current().params._projectId
      return doc

AutoForm.addHooks ['addArtifactForm', 'addGemForm', 'addSourceForm'],
  addToProjectHook
