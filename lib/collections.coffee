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

  artifacts:
    type: [String]
    minCount: 0
    optional: true
    label: 'Artifacts'
    allowedValues: ->
      return Artifacts.find(author: Meteor.userId()).map (doc) ->
        return doc._id
    autoform:
      options: ->
        return Artifacts.find(author: Meteor.userId()).map (doc) ->
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

  sources:
    type: [String]
    minCount: 1
    label: 'Source Documents'
    allowedValues: ->
      return Texts.find(author: Meteor.userId()).map (doc) ->
        return doc._id
    autoform:
      options: ->
        return Texts.find(author: Meteor.userId()).map (doc) ->
          return {label: doc.name, value: doc._id}

  artifacts:
    type: [String]
    minCount: 0
    optional: true
    label: 'Artifacts'
    allowedValues: ->
      return Artifacts.find(author: Meteor.userId()).map (doc) ->
        return doc._id
    autoform:
      options: ->
        return Artifacts.find(author: Meteor.userId()).map (doc) ->
          return {label: doc.name, value: doc._id}

  gems:
    type: [String]
    minCount: 0
    optional: true
    label: 'Gems'
    allowedValues: ->
      return Gems.find(author: Meteor.userId()).map (doc) ->
        return doc._id
    autoform:
      options: ->
        return Gems.find(author: Meteor.userId()).map (doc) ->
          return {label: doc.name, value: doc._id}

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
