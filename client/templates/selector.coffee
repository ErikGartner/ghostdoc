Template.selector_view.onRendered ->
  $('#selector_view').dropdown()
  @subscribe 'artifacts', ->
    id = Router.current().params._id
    $('#selector_view').dropdown 'set selected', id
  @subscribe 'texts', ->
    id = Router.current().params._id
    $('#selector_view').dropdown 'set selected', id

Template.selector_project.onRendered ->
  $('#selector_project').dropdown()
  @subscribe 'projects', ->
    projectId = Router.current().params._projectId
    $('#selector_project').dropdown 'set selected', projectId

Template.selector_view.helpers
  texts: ->
    projectId = Router.current().params._projectId
    project = Projects.findOne _id: projectId
    if project?.sources?
      return Texts.find {_id: $in: project.sources}

  artifacts: ->
    projectId = Router.current().params._projectId
    if not projectId?
      return
    project = Projects.findOne _id: projectId
    if project?.artifacts?
      return Artifacts.find {_id: $in: project.artifacts}, {sort: {name: 1}}

  _projectId: ->
    return Router.current().params._projectId

Template.selector_project.helpers
  projects: ->
    return Projects.find()
