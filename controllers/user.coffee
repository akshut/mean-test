async = require 'async'

module.exports = (User) ->

  signUp: (req, res, next) ->
    res.render 'users/signup', title: 'Sign up'

  signIn: (req, res, next) ->
    res.render 'users/signin', title: 'Sign in'

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

  buildDashboard: (req, res, next) ->

    user = req.user

    async.parallel {
      rooms: (cb) ->user.getRooms cb
      sessions: (cb) ->user.getSessions cb
    }, (err, data) ->

      res.render 'dashboard/dashboard', {data}
