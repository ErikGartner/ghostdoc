Template.selector_view.onRendered ->
  $('#selector_view').dropdown
    action: 'hide'
    fullTextSearch: true

Template.selector_project.onRendered ->
  $('#selector_project').dropdown
    action: 'hide'
    fullTextSearch: true

Template.selector_view.helpers
  texts: ->
    projectId = Router.current().params._projectId
    return Texts.find {project: projectId}

  artifacts: ->
    projectId = Router.current().params._projectId
    return Artifacts.find {project: projectId}, {sort: {name: 1}}

  _projectId: ->
    return Router.current().params._projectId

  activeSelection: ->
    id = Router.current().params._id
    artifact = Artifacts.findOne _id: id
    source = Texts.findOne _id: id
    if artifact?
      return artifact.name
    if source?
      return source.name
    return 'Sources/Artifacts'

Template.selector_project.helpers
  projects: ->
    return Projects.find()

  activeSelection: ->
    projectId = Router.current().params._projectId
    project = Projects.findOne _id: projectId
    if project?
      return project.name
    return 'Projects'
