Template.project.helpers
  sources: ->
    if @sources?
      return Texts.find({_id: $in: @sources},  {sort: {name: 1}}).map (doc) =>
        doc._projectId = @_id
        return doc

  artifacts: ->
    if @artifacts?
      return Artifacts.find({_id: $in: @artifacts}, {sort: {name: 1}}).map (doc) =>
        doc._projectId = @_id
        return doc

  gems: ->
    if @gems?
      return Gems.find({_id: $in: @gems}, {sort: {name: 1}}).map (doc) =>
        doc._projectId = @_id
        return doc
