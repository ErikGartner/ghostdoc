Template.project.helpers
  sources: ->
    if @sources?
      return Texts.find _id: $in: @sources

  artifacts: ->
    if @artifacts?
      return Artifacts.find _id: $in: @artifacts

  gems: ->
    if @gems?
      return Gems.find _id: $in: @gems
