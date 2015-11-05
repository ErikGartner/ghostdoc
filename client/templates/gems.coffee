Template.gems.helpers
  gems: ->
    return Gems.find {}, {sort:{name: 1}}
