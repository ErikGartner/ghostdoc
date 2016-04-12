Meteor.startup ->

  try
    # Setup external Ritter connection
    options =
      url: process.env.RABBITMQ_URL
    RabbitMQ.ensureConnection options
  catch error
    console.log 'Error when connecting to RabbitMQ'
