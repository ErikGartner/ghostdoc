Template.artifacts.helpers
  artifacts: ->
    return Artifacts.find {}, {sort:{name: 1}}
