require 'coffee-trace'

express       = require 'express'
config        = require './config'
helpers       = require 'view-helpers'
sse           = require 'connect-sse'
RedisStore    = require('connect-redis')(express)
app           = express()
loginRequired = require './middleware/requires-login'

config.resolve (user, room, DB_URL, PORT, passport, REDIS_HOST, REDIS_PORT, REDIS_PASS, session, Room) ->

  # Development set up
  app.configure 'development', ->
    app.use express.logger('dev')

  # Production set up
  app.configure 'production', ->

    # Enforce https, let's move this into the proxy
    app.get '*', (req, res, next) ->
      if not req.secure
        return res.redirect "https://#{req.get('Host')}#{req.url}"
      next()

  # General configure
  app.configure ->
    app.use express.favicon()
    app.use express.static "#{__dirname}/public"

    app.set 'views', "#{__dirname}/views"
    app.set 'view engine', 'jade'

    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.session
      secret: 'doxy'
      store: new RedisStore host: REDIS_HOST, port: REDIS_PORT, pass: REDIS_PASS
    app.use express.csrf()

    app.use (req, res, next) ->
      res.locals.csrf_token = req.csrfToken()
      next()

    app.use helpers 'Doxy.me'

    app.use passport.initialize()
    app.use passport.session()

    app.use (err, req, res, next) ->
      console.log """
        Error occurred:

        #{err.stack}

      """
      res.send 500, 'An error occurred'

  ###
  #
  # R O U T E S
  #
  ###

  # Home page
  app.get '/', (req, res, next) ->
    res.render 'index'


  ###
  # Sign-up flow
  ###
  app.get '/e4125f1c0b5e409fc667a7b3b34add9b3a1357ff', user.signUp

  app.get '/i/signin', user.signIn
  app.get '/i/request', user.request

  app.post '/i/signin', passport.authenticate('local',
      failureRedirect: '/i/signin'
      failurFlash: 'Invalid email or password'
    ), user.logIn

  app.get '/i/signout', user.signOut

  app.post '/i/users', user.create

  ###
  # Room things
  ###
  app.get '/i/dashboard', loginRequired, user.buildDashboard
  app.post '/i/rooms', room.create

  app.get '/session/:id', sse(), session.open

  # This route must always stay as low as possible, to catch any possible room
  app.get '/:roomName', room.joinRoomByName

  app.get '/:roomSlug/sessions', loginRequired, (req, res, next) ->
    slug = req.param 'roomSlug'
    Room.findOne {slug, acl: req.user.email}, (err, room) ->
      return next err if err
      return res.send '403', "Unauthorized for room #{name}" if not room
      next()
  , sse(), room.openSessions

  # 404 route
  app.get '*', (req, res, next) ->
    res.send 404, 'Page not found'

  app.listen PORT

  console.log """

  Doxy.me running at port: #{PORT}

  """
