crypto   = require 'crypto'
mongoose = require 'mongoose'
Schema   = mongoose.Schema

module.exports = (db, SALT, Room) ->

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

  db.model 'User', UserSchema
