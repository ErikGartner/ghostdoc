Template.home.helpers
  topProjects: ->
    return Projects.find {}, {sort: {name: 1}}

  topSources: ->
    return Texts.find {project: @_id},  {limit: 5, sort: {name: 1}}

  topArtifacts: ->
    return Artifacts.find {project: @_id}, {limit: 5, sort: {name: 1}}
