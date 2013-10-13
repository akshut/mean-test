require 'coffee-trace'

express       = require 'express'
config        = require './config'
helpers       = require 'view-helpers'
mongoStore    = require('connect-mongo')(express)
app           = express()
loginRequired = require './middleware/requires-login'

config.resolve (user, room, DB_URL, PORT, passport) ->

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

  app.use express.favicon()
  app.use express.static "#{__dirname}/public"

  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'

  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.session
    secret: 'doxy'
    store: new mongoStore url: DB_URL, collection: 'sessions'

  app.use helpers 'Doxy.me'

  app.use passport.initialize()
  app.use passport.session()

  app.use (err, req, res, next) ->
    console.log """
      Error occurred:

      #{err.stack}

    """
    res.send 500, 'An error occurred'

  # Home page
  app.get '/', (req, res, next) ->
    res.render 'index'

  ###
  #
  # R O U T E S
  #
  ###

  ###
  # Sign-up flow
  ###
  app.get '/e4125f1c0b5e409fc667a7b3b34add9b3a1357ff', user.signUp

  app.get '/i/signin', user.signIn

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

  # This route must always stay as low as possible, to catch any possible room
  app.get '/:roomName', room.joinRoomByName

  app.get '/:roomName/events', loginRequired, room.eventsForRoom

  # 404 route
  app.get '*', (req, res, next) ->
    res.send 404, 'Page not found'

  app.listen PORT

  console.log """

  Doxy.me running at port: #{PORT}

  """
