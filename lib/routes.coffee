Router.configure
  layoutTemplate: 'ApplicationLayout'
  trackPageView: true
  subscriptions: ->
    Meteor.subscribe 'list.projects'

Router.route '/',
  name: 'home'
  action: ->
    @render 'home'

Router.route '/project',
  name: 'project.add',
  action: ->
    @render 'addProject'

Router.route '/project/:_projectId',
  name: 'project.view'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'project', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Projects.findOne _id: @params._projectId
        return data
    }

Router.route '/project/:_projectId/edit',
  name: 'project.edit',
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'editProject', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Projects.findOne _id: @params._projectId
        return data
    }

Router.route '/project/:_projectId/source',
  name: 'source.add'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'addSource'

Router.route '/project/:_projectId/source/:_id/edit',
  name: 'source.edit'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'editSource', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Texts.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/source/:_id',
  name: 'source.view'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'source', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Texts.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/artifact',
  name: 'artifact.add'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'addArtifact'

Router.route '/project/:_projectId/artifact/:_id',
  name: 'artifact.view'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'artifact', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Artifacts.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/artifact/:_id/edit',
  name: 'artifact.edit'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'editArtifact', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Artifacts.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/gem',
  name: 'gem.add'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'addGem'

Router.route '/project/:_projectId/gem/:_id/edit',
  name: 'gem.edit'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'editGem', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Gems.findOne _id: @params._id
        return data
    }

Router.route '/project/:_projectId/gem/:_id',
  name: 'gem.view'
  subscriptions: ->
    Meteor.subscribe 'get.project', @params._projectId
  action: ->
    @render 'viewGem', {
      data: ->
        data = {projectId: @params._projectId}
        _.extend data, Gems.findOne _id: @params._id
        return data
    }
