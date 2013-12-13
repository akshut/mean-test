require 'coffee-trace'

express       = require 'express'
config        = require './config'
helpers       = require 'view-helpers'
sse           = require 'connect-sse'
RedisStore    = require('connect-redis')(express)
app           = express()
loginRequired = require './middleware/requires-login'

config.resolve (user, room, DB_URL, PORT, passport, REDIS_HOST, REDIS_PORT, REDIS_PASS, session, Room) ->

  roomExists = (req, res, next) ->
    slug = req.param 'roomSlug'
    query = {slug, acl: req.user?.email || '*'}

    Room.findOne query, (err, room) ->
      return next err if err
      return res.send '403', "Unauthorized for room #{room.name}" if not room
      next()

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
    if req.user
      res.redirect("/i/dashboard")
    else
      res.render 'index'


  # When user goes to meeting directory, redirect them to a room (timestamp)
  app.get '/quick', (req, res, next) ->
    req.session.isDemo = true
    res.redirect( "/i/demo/#{RandomRoom()}" )

  # Random Room Generator - inspired by webrtcio guys on github
  RandomRoom = ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz"
    length_of_string = 9
    randomstring = ""
    i = 0

    while i < length_of_string
      random_num = Math.floor(Math.random() * chars.length)
      randomstring += chars.substring(random_num, random_num + 1)
      i++
    randomstring

  ###
  # Sign-up flow
  ###
  app.get '/i/signup', user.signUp

  app.get '/i/signin', user.signIn
  app.get '/i/request', user.request

  app.post '/i/signin', passport.authenticate('local',
      failureRedirect: '/i/signin'
      failurFlash: 'Invalid email or password'
    ), user.logIn

  app.get '/i/signout', user.signOut

  app.post '/i/users', user.create

  ###
  # Demo
  ###
  app.get '/i/demo/:roomSlug', user.buildDemoDash
  app.get '/i/demo/:roomSlug/sessions', roomExists, sse(), room.openSessions

  ###
  # Room things
  ###
  app.get '/i/dashboard', loginRequired, user.buildDashboard
  app.post '/i/rooms', room.create

  app.get '/session/:id', sse(), session.open

  # This route must always stay as low as possible, to catch any possible room
  app.get '/:roomName', room.joinRoomByName

  app.get '/:roomSlug/sessions', loginRequired, roomExists, sse(), room.openSessions

  # 404 route
  app.get '*', (req, res, next) ->
    res.send 404, 'Page not found'

  app.listen PORT

  console.log """

  Doxy.me running at port: #{PORT}

  """
