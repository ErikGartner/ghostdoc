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

  categories:
    type: [String]
    label: 'Categories'

  tokens:
    type: [String]
    label: 'Tokens/Aliases'
  
  author:
    type: String
    label: 'Author ID'

Texts.attachSchema Schemas.Texts
Artifacts.attachSchema Schemas.Artifacts
