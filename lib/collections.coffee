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

  text:
    type: String
    label: 'Text'

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
)
