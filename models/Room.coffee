mongoose = require('mongoose')
Schema   = mongoose.Schema

module.exports = (db) ->

  RoomSchema = new Schema

    created:
      type: Date
      default: Date.now

    dr:
      type: String
      lowercase: true
      default: 'DrX'
      trim: true

    sessionId:
      type: String
      default: '123456789'
      trim: true

    user:
      type: Schema.ObjectId
      ref: 'User'

    token:
      type: String
      default: 'asdf1234'

  db.model 'Room', RoomSchema
