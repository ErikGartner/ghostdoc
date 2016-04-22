Template.infobox.helpers
  gemsItems: ->
    if not @_id? or not @projectId? or not @isProcessed()
      return
    return @analytics().data.gems.data

  associates: ->
    if not @_id? or not @projectId?
      return

    project = Projects.findOne(@projectId)
    if not project? or not project.isProcessed()
      return false

    data = project.analytics().data.network_analytics
    communityId = data.communities[@_id]
    centrality = data.centrality[@_id]

    community = _.filter Artifacts.find({project: @projectId}).fetch(), (doc) ->
      return data.communities[doc._id] == communityId and doc._id != @_id
    , {_id: @_id}

    community = _.sortBy community, (doc) ->
      return -1 *data.centrality[doc._id]

    return _.first community, 5
