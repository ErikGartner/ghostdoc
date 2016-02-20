Template.home.helpers
  topProjects: ->
    return Projects.find {}, {sort: {name: 1}}

  topSources: ->
    if @sources?
      return Texts.find({_id: $in: @sources}, {limit: 5, sort: {name: 1}}).map (doc) =>
        doc._projectId = @_id
        return doc

  topArtifacts: ->
    if @artifacts?
      return Artifacts.find({_id: $in: @artifacts}, {limit: 5, sort: {name: 1}}).map (doc) =>
        doc._projectId = @_id
        return doc
