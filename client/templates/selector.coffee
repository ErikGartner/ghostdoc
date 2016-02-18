Template.selector_view.onRendered ->
  $('#selector_view').dropdown
    onChange: (value, text, $selectedItem) ->
      type = $($selectedItem).data('type')
      projectId = Router.current().params._projectId
      Router.go type + '.view', {_projectId: projectId, _id: value}

Template.selector_project.onRendered ->
  $('#selector_project').dropdown
    onChange: (value, text, $selectedItem) ->
      Router.go 'project.view', {_projectId: value}

Template.selector_view.helpers
  texts: ->
    project = Projects.findOne _id: Router.current().params._projectId
    if project?.sources?
      return Texts.find {_id: $in: project.sources}

  artifacts: ->
    projectId = Router.current().params._projectId
    if not projectId?
      return
    project = Projects.findOne _id: Router.current().params._projectId
    if project?.artifacts?
      return Artifacts.find {_id: $in: project.artifacts}, {sort: {name: 1}}

Template.selector_project.helpers
  projects: ->
    return Projects.find()
