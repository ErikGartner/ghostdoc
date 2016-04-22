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

    return _.first assocs, 5

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
      console.log doc._id, @_id
      return doc._id == currentId

    return rank + 1
