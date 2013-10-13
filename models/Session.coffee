Schema = require('mongoose').Schema

module.exports = (db) ->

  roomName: type: String, required: true

  token: String

  sessionId: String
