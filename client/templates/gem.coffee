Template.editGem.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()

Template.viewGem.onCreated ->
  @autorun ->
    # Get data on collection changes
    currentGemId = Router.current().params._id
    projectId = Router.current().params._projectId

    data = Artifacts.find({'project': projectId}, {sort: {name: 1}}).map (artifact) ->
      gems = artifact.analytics()?.data?.gems.data
      gems = _.filter gems, (g) ->
        return g._id == currentGemId
      if gems.length > 0
        return {artifact: artifact, gems: gems}
      else
        return []
    Session.set 'all_values', _.flatten data

  @autorun ->
    # Filter data on search value changes
    data = Session.get 'all_values'
    filter = Session.get('filter_value').toLowerCase()
    if filter? and filter != ""
      data = _.filter data, (a) ->
        return _.find a.gems, (g) ->
          return _.find g.result, (v) ->
            return v.toLowerCase().indexOf(filter) > -1

    Session.set 'values', data

Template.viewGem.helpers
  artifacts: ->
    return Session.get 'values'

  filter: ->
    return Session.get 'filter_value'

Template.viewGem.events
  'input #gemsearch': _.throttle((event) ->
    filterValue = $('#gemsearch').val()
    Session.set 'filter_value', filterValue
  , 500)
