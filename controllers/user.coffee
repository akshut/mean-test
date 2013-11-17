async = require 'async'

module.exports = (User) ->

  signUp: (req, res, next) ->
    res.render 'users/signup', title: 'Sign up'

  signIn: (req, res, next) ->
    res.render 'users/signin', title: 'Sign in'

  request: (req, res, next) ->
    res.render 'users/request', title: 'Request'

  logIn: (req, res, next) ->
    res.redirect '/i/dashboard'

  signOut: (req, res, next) ->
    req.logout()
    res.redirect '/'

  create: (req, res, next) ->
    user = new User req.body
    user.save (err) ->
      if err
        return res.render 'users/signup', errors: err.errors, user: user

      req.login user, (err) ->
        return next err if err
        res.redirect '/i/dashboard'

  buildDemoDash: (req, res, next) ->
    User.getDemoRoom req.param('roomSlug'), (err, room) ->
      return next err if err
      res.render 'dashboard/dashboard', {room}

  buildDashboard: (req, res, next) ->

    user = req.user

    user.getRoomsWithSessions (err, rooms) ->
      return next err if err

      res.render 'dashboard/dashboard', {rooms}
