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

  markedTree:
    type: String
    label: 'Marked Tree'
    autoValue: (doc) ->
      try
        return JSON.stringify(marked.lexer @field('text').value)
      catch error
        console.log 'Error when parsing for markedTree', @name, error
        return ''

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

  trello_user_key:
    type: String
    optional: true
    label: 'Trello API user key'

  trello_org_id:
    type: String
    optional: true
    label: 'Trello API Organization id'

Texts.attachSchema Schemas.Text
Artifacts.attachSchema Schemas.Artifact
Gems.attachSchema Schemas.Gem
Projects.attachSchema Schemas.Project

Meteor.users.helpers
  mail: ->
    if @emails?
      return @emails[0].address
    else if @services?.facebook?.email
      return @services.facebook.email
    return undefined

Artifacts.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    if userId == doc.author
      return true

    collaborators = Projects.findOne(doc.project)?.collaborators
    if collaborators? and Meteor.users.findOne(userId).mail() in collaborators
      return true

    return false

  remove: (userId, doc) ->
    return userId == doc.author
)

Texts.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    if userId == doc.author
      return true

    collaborators = Projects.findOne(doc.project)?.collaborators
    if collaborators? and Meteor.users.findOne(userId).mail() in collaborators
      return true

    return false

  remove: (userId, doc) ->
    return userId == doc.author
)

Gems.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    if userId == doc.author
      return true

    collaborators = Projects.findOne(doc.project)?.collaborators
    if collaborators? and Meteor.users.findOne(userId).mail() in collaborators
      return true

    return false

  remove: (userId, doc) ->
    return userId == doc.author
)

Projects.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    if userId == doc.author
      return true

    if doc.collaborators? and Meteor.users.findOne(userId).mail() in
        doc.collaborators
      return true

    return false

  remove: (userId, doc) ->
    return userId == doc.author
)
