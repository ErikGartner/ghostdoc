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
    pairs = data.pair_occurences[@_id]

    assocs = _.filter Artifacts.find({project: @projectId}).fetch(), (doc) ->
      return pairs[doc._id]? and doc._id != @_id
    , {_id: @_id}

    assocs = _.sortBy assocs, (doc) ->
      return -1 * pairs[doc._id]

    assocs = _.first assocs, 5
    assocs = _.map assocs, (doc) ->
      doc._occurrences = pairs[doc._id]
      return doc
    return assocs

  rank: ->
    if not @_id? or not @projectId?
      return

    project = Projects.findOne(@projectId)
    if not project? or not project.isProcessed()
      return false

    data = project.analytics().data.network_analytics
    ranks = _.sortBy Artifacts.find({project: @projectId}).fetch(), (doc) ->
      return -1 * data.centrality[doc._id]

    currentId = @_id
    rank = lodash.findIndex ranks, (doc) ->
      return doc._id == currentId

    return rank + 1

  community: ->
    if not @_id? or not @projectId?
      return

    project = Projects.findOne(@projectId)
    if not project? or not project.isProcessed()
      return false

    data = project.analytics().data.network_analytics
    communityId = data.communities[@_id]
    centrality = data.centrality[@_id]
    pairs = data.pair_occurences[@_id]

    community = _.filter Artifacts.find({project: @projectId}).fetch(), (doc) ->
      return data.communities[doc._id] == communityId and doc._id != @_id
    , {_id: @_id}

    community = _.sortBy community, (doc) ->
      return -1 * data.centrality[doc._id]

    return _.first community, 3

  communitySize: (community) ->
    if not @_id? or not @projectId?
      return

    project = Projects.findOne(@projectId)
    if not project? or not project.isProcessed()
      return false

    data = project.analytics().data.network_analytics
    communityId = data.communities[@_id]
    centrality = data.centrality[@_id]
    pairs = data.pair_occurences[@_id]

    community = _.filter Artifacts.find({project: @projectId}).fetch(), (doc) ->
      return data.communities[doc._id] == communityId
    , {_id: @_id}
    return community.length
