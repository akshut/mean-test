OpenTok  = require 'opentok'
mongoose = require 'mongoose'
Schema   = mongoose.Schema

module.exports = (db, API_KEY, SECRET, Session) ->

  opentok = new OpenTok.OpenTokSDK API_KEY, SECRET

  RoomSchema = new Schema

    created:
      type: Date
      default: Date.now

    # How we'll identify rooms internally
    slug:
      type: String
      unique: true
      lowercase: true
      required: true
      trim: true

    # The true "branding" of the room name
    name:
      type: String
      unique: true
      required: true
      trim: true

    acl: type: [String], default: []

  RoomSchema.statics.joinByName = (name, cb) ->
    slug = name.toLowerCase()
    @findOne {slug}, (err, room) ->
      return cb err if err
      if not room?
        return cb new Error "No room exists under name #{name}"

      opentok.createSession null, {'p2p.preference': 'enabled'}, (sessionId) ->
        token = opentok.generateToken {session_id: sessionId}

        session = new Session {sessionId, token, roomSlug: slug, API_KEY}
        session.save (err) ->
          cb err, session

  db.model 'Room', RoomSchema
