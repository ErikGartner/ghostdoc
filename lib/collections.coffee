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
    label: 'Tokens/Aliases'

  image:
    type: String
    optional: true
    label: 'Image url'

  author:
    type: String
    label: 'Author ID'

  text:
    type: String
    label: 'Document ID'

Texts.attachSchema Schemas.Texts
Artifacts.attachSchema Schemas.Artifacts
