Meteor.methods
  saveText: (id, text) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    check text, String
    if id?
      data = Texts.findOne author: uid, _id: id
      if not data?
        throw new Meteor.Error('invalid id')

    tree = marked.lexer(text)
    name = 'Untitled (Missing header)'
    for item in tree
      if item.type == 'heading'
        name = item.text
        break

    data =
      author: uid
      name: name
      text: text

    if id?
      Texts.update {_id:id}, {$set: data}
    else
      id = Texts.insert data
    return id

  deleteText: (id) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    Texts.remove _id:id, author: uid
