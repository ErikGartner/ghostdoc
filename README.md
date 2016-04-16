# Ghostdoc
*A smart text viewer that semi-automatically identifies, highlights and summarizes
based on artifacts.*

The purpose of this app is to take large texts such as articles, journals or even books and extract information regarding so-called *artifacts* (persons, places etc). That way it becomes easy for the viewer to get a summary of all relevant information about an artifact found in the source material.

## Ritter
The web app is backed by [Ritter](https://github.com/ErikGartner/ghostdoc-ritter), a python data processing engine. When the user updates a source or artifact definition a message is sent to an instance of *Ritter* that then processes the data and returns it to the web app.

*Ghostdoc* and *Ritter* instances communicates via a RabbitMQ broker and works against a shared Mongo database.

## Installation
Ghostdoc and Ritter is optimized for running on Dokku but can run anywhere that supports NodeJS and Python 3.5.

- Setup a Mongo database
- Setup a RabbitMQ broker
- Setup [Ritter](https://github.com/ErikGartner/ghostdoc-ritter)
- Set the follwing environment variables:
```
MONGO_URL
RABBITMQ_URL
ROOT_URL
```
