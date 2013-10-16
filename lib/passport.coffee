passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

module.exports = (User) ->

  passport.serializeUser (user, done) ->
    done null, user._id

  passport.deserializeUser (_id, done) ->
    User.findOne {_id}, done

  passport.use new LocalStrategy {usernameField: 'email'}, (email, password, done) ->
    User.findOne {email}, (err, user) ->
      return done err if err

      if not user
        return done null, false, message: 'Unkown user'

      if not user.authenticate password
        return done null, false, message: 'Invalid password'

      done null, user

  passport
