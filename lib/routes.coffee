Router.route('/', ->
  GAnalytics.pageview()
  @render('editor')
)

Router.configure
  layoutTemplate: 'ApplicationLayout'

Router.route '/doc',
  name: 'doc.add'
  action: ->
    GAnalytics.pageview()
    @render 'editor'

Router.route '/doc/:_id/edit',
  name: 'doc.edit'
  action: ->
    GAnalytics.pageview()
    @render 'editor', {
      data: ->
        return Texts.findOne _id: @params._id
    }

Router.route '/doc/:_id',
  name: 'doc.view'
  action: ->
    GAnalytics.pageview()
    @render 'viewer', {
      data: ->
        return Texts.findOne _id: @params._id
    }

Router.route '/artifact/:_id',
  name: 'artifact.view'
  action: ->
    GAnalytics.pageview()
    @render 'artifact', {
      data: ->
        return Artifacts.findOne _id: @params._id
    }

Router.route '/artifact/:_id/edit',
  name: 'artifact.edit'
  action: ->
    GAnalytics.pageview()
    @render 'editArtifact', {
      data: ->
        return Artifacts.findOne _id: @params._id
    }

Router.route '/artifact',
  name: 'artifact.add'
  action: ->
    GAnalytics.pageview()
    @render 'addArtifact'
