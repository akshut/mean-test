crypto   = require 'crypto'
mongoose = require 'mongoose'
Schema   = mongoose.Schema

module.exports = (db, SALT) ->

  encryptPassword = (password) ->
    crypto.createHmac('sha1', SALT).update(password).digest('hex')

  UserSchema = Schema
    name:  type: String, required: true
    email: type: String, required: true
    password: type: String, required: true, set: encryptPassword
    #rooms: type: Array, lowercase: true, trim: true, required: true

  UserSchema.methods.authenticate = (password) -> @password is encryptPassword password

  db.model 'User', UserSchema
