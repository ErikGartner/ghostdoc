Router.configure
  layoutTemplate: 'ApplicationLayout'

Router.route '/',
  name: 'home'
  action: ->
    @render 'viewer'

Router.route '/project',
  name: 'project.add',
  action: ->
    @render 'addProject'

Router.route '/project/:_projectId',
  name: 'project.view',
  action: ->
    @render 'project', {
      data: ->
        return Projects.findOne _id: @params._projectId
    }

Router.route '/project/:_projectId/edit',
  name: 'project.edit',
  action: ->
    @render 'editProject', {
      data: ->
        return Projects.findOne _id: @params._projectId
    }

Router.route '/doc',
  name: 'doc.add'
  action: ->
    @render 'editor'

Router.route '/project/:_projectId/doc/:_id/edit',
  name: 'doc.edit'
  action: ->
    @render 'editor', {
      data: ->
        return Texts.findOne _id: @params._id
    }

Router.route '/project/:_projectId/doc/:_id',
  name: 'doc.view'
  action: ->
    @render 'viewer', {
      data: ->
        return Texts.findOne _id: @params._id
    }

Router.route '/project/:_projectId/artifact/:_id',
  name: 'artifact.view'
  action: ->
    @render 'artifact', {
      data: ->
        return Artifacts.findOne _id: @params._id
    }

Router.route '/project/:_projectId/artifact/:_id/edit',
  name: 'artifact.edit'
  action: ->
    @render 'editArtifact', {
      data: ->
        return Artifacts.findOne _id: @params._id
    }

Router.route '/artifact',
  name: 'artifact.add'
  action: ->
    @render 'addArtifact'

Router.route '/gem/:_id/edit',
  name: 'gem.edit'
  action: ->
    @render 'editGem', {
      data: ->
        return Gems.findOne _id: @params._id
    }

Router.route '/gem',
  name: 'gem.add'
  action: ->
    @render 'addGem'
