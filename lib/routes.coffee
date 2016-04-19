Router.configure
  layoutTemplate: 'ApplicationLayout'

Router.route '/',
  name: 'home'
  action: ->
    @render 'home'

Router.route '/project',
  name: 'project.add',
  action: ->
    @render 'addProject'

Router.route '/project/:_projectId',
  name: 'project.view',
  action: ->
    @render 'project', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Projects.findOne _id: @params._projectId
        return data
    }

Router.route '/project/:_projectId/edit',
  name: 'project.edit',
  action: ->
    @render 'editProject', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Projects.findOne _id: @params._projectId
        return data
    }

Router.route '/project/:_projectId/source',
  name: 'source.add'
  action: ->
    @render 'addSource'

Router.route '/project/:_projectId/source/:_id/edit',
  name: 'source.edit'
  action: ->
    @render 'editSource', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Texts.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/source/:_id',
  name: 'source.view'
  action: ->
    @render 'source', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Texts.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/artifact',
  name: 'artifact.add'
  action: ->
    @render 'addArtifact'

Router.route '/project/:_projectId/artifact/:_id',
  name: 'artifact.view'
  action: ->
    @render 'artifact', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Artifacts.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/artifact/:_id/edit',
  name: 'artifact.edit'
  action: ->
    @render 'editArtifact', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Artifacts.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/gem',
  name: 'gem.add'
  action: ->
    @render 'addGem'

Router.route '/project/:_projectId/gem/:_id/edit',
  name: 'gem.edit'
  action: ->
    @render 'editGem', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Gems.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/source/:_id/network',
  name: 'network.view'
  waitOn: ->
    return Meteor.subscribe 'projects'

  action: ->
    @render 'network', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Texts.findOne _id: @params._id
        return data
    }
