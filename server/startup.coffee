Meteor.startup ->

  try
    # Setup external Ritter connection
    options =
      host: process.env.RABBITMQ_URL
    RabbitMQ.ensureConnection options
  catch error
    console.log 'Error when connecting to RabbitMQ'
