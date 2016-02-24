Template.project.helpers
  sources: ->
    return Texts.find {project: @_id},  {sort: {name: 1}}

  artifacts: ->
    return Artifacts.find {project: @_id}, {sort: {name: 1}}

  gems: ->
    return Gems.find {project: @_id}, {sort: {name: 1}}

  authorName: ->
    return Meteor.users.findOne(_id: @author)?.profile?.name
