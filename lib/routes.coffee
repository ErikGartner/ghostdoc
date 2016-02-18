Router.configure
  layoutTemplate: 'ApplicationLayout'

Router.route '/',
  name: 'home'
  action: ->
    @render 'viewer'

Router.route '/doc',
  name: 'doc.add'
  action: ->
    @render 'editor'

Router.route '/doc/:_id/edit',
  name: 'doc.edit'
  action: ->
    @render 'editor', {
      data: ->
        return Texts.findOne _id: @params._id
    }

Router.route '/doc/:_id',
  name: 'doc.view'
  action: ->
    @render 'viewer', {
      data: ->
        return Texts.findOne _id: @params._id
    }

Router.route '/artifact/:_id',
  name: 'artifact.view'
  action: ->
    @render 'artifact', {
      data: ->
        return Artifacts.findOne _id: @params._id
    }

Router.route '/artifact/:_id/edit',
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

Router.route '/project/:_id',
  name: 'project.view',
  action: ->
    @render 'project'
