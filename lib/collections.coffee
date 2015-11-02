@Texts = new Mongo.Collection('texts')
@Artifacts = new Mongo.Collection('artifacts')

@Schemas = {}
Schemas.Texts = new SimpleSchema
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

  collaborators:
    type: [String]
    optional: true
    minCount: 0
    label: 'Collaborator email'

  updatedAt:
    type: Date
    label: 'Last updated'
    autoValue: ->
      if @isUpdate or @isInsert
        return new Date()

Schemas.Artifacts = new SimpleSchema
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

  texts:
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

Texts.attachSchema Schemas.Texts
Artifacts.attachSchema Schemas.Artifacts

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

Meteor.users.helpers
  mail: ->
    if @emails?
      return @emails[0].address
    else if @services?.facebook?.email
      return @services.facebook.email
    return undefined

@textIndex = new EasySearch.Index
  collection: Texts,
  fields: ['name'],
  engine: new EasySearch.MongoDB()

@artifactIndex = new EasySearch.Index
  collection: Artifacts,
  fields: ['name'],
  engine: new EasySearch.MongoDB()
