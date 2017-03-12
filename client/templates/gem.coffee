Template.editGem.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()

Template.viewGem.helpers
  artifacts: ->
    currentGemId = @_id
    filterValue = @gemValue?.toLowerCase()
    artifacts = Artifacts.find({'project': @projectId}, {sort: {name: 1}}).map (artifact) ->
      gems = artifact.analytics()?.data?.gems.data
      gems = _.filter gems, (g) ->
        if filterValue?
          return g._id == currentGemId and _.find(g.result, (r) ->
            ("" + r).toLowerCase() == filterValue)?
        else
          return g._id == currentGemId
      if gems.length > 0
        return {artifact: artifact, gems: gems}
      else
        return []

    return _.flatten artifacts

  filterValue: ->
    return @gemValue
