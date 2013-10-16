Schema = require('mongoose').Schema

module.exports = (db) ->

  SessionSchema = new Schema
    roomSlug: type: String, required: true

    token: String

    API_KEY: String

    sessionId: String

    # Expire sessions after 6 hours
    createdAt: type: Date, default: Date.now, expires: 60 * 60 * 6

  db.model 'Session', SessionSchema
