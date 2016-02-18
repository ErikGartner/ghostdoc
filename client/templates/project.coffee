Template.project.helpers
  sources: ->
    return Texts.find _id: $in: @sources

  artifacts: ->
    return Artifacts.find _id: $in: @artifacts

  gems: ->
    return Gems.find _id: $in: @gems
