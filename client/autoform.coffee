addToProjectHook =
  after:
    insert: (err, res) ->
      if not err?
        console.log res, @


AutoForm.addHooks ['addArtifactForm'] , addToProjectHook
