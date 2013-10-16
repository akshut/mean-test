crypto   = require 'crypto'
async    = require 'async'
mongoose = require 'mongoose'
Schema   = mongoose.Schema

module.exports = (db, SALT, Room, activeSessions) ->

  encryptPassword = (password) ->
    crypto.createHmac('sha1', SALT).update(password).digest('hex')

  UserSchema = Schema
    firstName: type: String, required: true
    lastName: type: String, required: true
    email: type: String, required: true
    password: type: String, required: true, set: encryptPassword
    #rooms: type: Array, lowercase: true, trim: true, required: true

  UserSchema.virtual('fullName').get -> "#{firstName} #{lastName}"

  UserSchema.methods.authenticate = (password) -> @password is encryptPassword password

  UserSchema.methods.getRooms = (cb) ->
    Room.find({acl: @email})
        .lean()
        .select('name slug')
        .exec cb

  UserSchema.methods.getRoomsWithSessions = (cb) ->
    @getRooms (err, rooms) ->
      return cb err if err

      async.map rooms, (room, cb) ->
        activeSessions.getSessionsForRoom room.slug, (err, sessions) ->
          room.sessions = sessions
          cb null, room
      , cb

  db.model 'User', UserSchema
