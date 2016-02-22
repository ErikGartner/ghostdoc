@Texts = new Mongo.Collection('texts')
@Artifacts = new Mongo.Collection('artifacts')
@Gems = new Mongo.Collection('gems')
@Projects = new Mongo.Collection('projects')

@Schemas = {}
Schemas.Text = new SimpleSchema
  name:
    type: String
    label: 'Name'
    max: 300

  author:
    type: String
    label: 'Author ID'
    autoValue: ->
      if @isInsert
        return Meteor.userId()

  text:
    type: String
    label: 'Text'

  updatedAt:
    type: Date
    label: 'Last updated'
    autoValue: ->
      if @isUpdate or @isInsert
        return new Date()

  project:
    type: String
    label: 'Project'
    allowedValues: ->
      return Projects.find(author: Meteor.userId()).map (doc) ->
        return doc._id
    autoform:
      options: ->
        return Projects.find(author: Meteor.userId()).map (doc) ->
          return {label: doc.name, value: doc._id}

Schemas.Gem = new SimpleSchema
  name:
    type: String
    label: 'Name'
    max: 50

  author:
    type: String
    label: 'Author'
    autoValue: ->
      if @isInsert
        return Meteor.userId()

  patterns:
    type: [String]
    label: 'Pattern'

  project:
    type: String
    label: 'Project'
    allowedValues: ->
      return Projects.find(author: Meteor.userId()).map (doc) ->
        return doc._id
    autoform:
      options: ->
        return Projects.find(author: Meteor.userId()).map (doc) ->
          return {label: doc.name, value: doc._id}

Schemas.Artifact = new SimpleSchema
  name:
    type: String
    label: 'Name'
    max: 300

  tokens:
    type: [String]
    minCount: 1
    label: 'Token'

  image:
    type: String
    optional: true
    label: 'Image URL'

  author:
    type: String
    label: 'Author ID'
    autoValue: ->
      if @isInsert
        return Meteor.userId()

  project:
    type: String
    label: 'Project'
    allowedValues: ->
      return Projects.find(author: Meteor.userId()).map (doc) ->
        return doc._id
    autoform:
      options: ->
        return Projects.find(author: Meteor.userId()).map (doc) ->
          return {label: doc.name, value: doc._id}

Schemas.Project = new SimpleSchema
  name:
    type: String
    label: 'Name'
    max: 300

  description:
    type: String
    label: 'Description'
    max: 1000

  author:
    type: String
    label: 'Author ID'
    autoValue: ->
      if @isInsert
        return Meteor.userId()

  collaborators:
    type: [String]
    optional: true
    minCount: 0
    label: 'Collaborator email'

Texts.attachSchema Schemas.Text
Artifacts.attachSchema Schemas.Artifact
Gems.attachSchema Schemas.Gem
Projects.attachSchema Schemas.Project

Artifacts.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    return userId == doc.author

  remove: (userId, doc) ->
    return userId == doc.author
)

Texts.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    return userId == doc.author

  remove: (userId, doc) ->
    return userId == doc.author
)

Gems.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    return userId == doc.author

  remove: (userId, doc) ->
    return userId == doc.author
)

Projects.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    return userId == doc.author

  remove: (userId, doc) ->
    return userId == doc.author
)

Meteor.users.helpers
  mail: ->
    if @emails?
      return @emails[0].address
    else if @services?.facebook?.email
      return @services.facebook.email
    return undefined
