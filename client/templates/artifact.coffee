Template.artifactSummary.helpers
  artifact: ->
    return Artifacts.findOne(_id:Session.get('selectedArtifact'))

  references: ->
    data = []
    $('.token[data-id="' + Session.get('selectedArtifact') + '"').each((index) ->
      paragraph = $(this).parent().html()
      token = $(this).text()
      console.log $(this)
      paragraph = S(paragraph).replaceAll($(this)[0].outerHTML, token).s
      console.log paragraph
      data.push paragraph
    )
    return data
