path     = require 'path'
url      = require 'url'
deps     = require('dependable').container()
mongoose = require 'mongoose'

# Constants
if process.env.DB_URL
  MONGODB_URL = process.env.DB_URL
else if process.env.MONGOLAB_URI
  MONGODB_URL = "#{process.env.MONGOLAB_URI}"
else
  MONGODB_URL= "mongodb://localhost/doxyme"

if process.env.REDIS_URL? or process.env.REDISTOGO_URL?
  redisUrl = process.env.REDIS_URL or process.env.REDISTOGO_URL
  parsedUrl = url.parse redisUrl
  REDIS_HOST = parsedUrl.hostname
  REDIS_PORT = +parsedUrl.port
  REDIS_PASS = parsedUrl.auth.split(':')[1]
else
  REDIS_HOST = 'localhost'
  REDIS_PORT = 6379
  REDIS_PASS = ''

deps.register 'ENV'        , (process.env.NODE_ENV   || 'development')
deps.register 'DB_URL'     , MONGODB_URL
deps.register 'SALT'       , (process.env.SALT       || 'd417868719d0077ecb1f9830658030cb')
deps.register 'PORT'       , (process.env.PORT       || 3000)
deps.register 'API_KEY'    , (process.env.API_KEY    || 36591572)
deps.register 'SECRET'     , (process.env.SECRET     || process.env.APIKEY2)
deps.register 'REDIS_HOST' , REDIS_HOST
deps.register 'REDIS_PORT' , REDIS_PORT
deps.register 'REDIS_PASS' , REDIS_PASS

deps.register 'db', mongoose.connect(deps.get('DB_URL'))

deps.load path.join __dirname, 'lib'
deps.load path.join __dirname, 'models'
deps.load path.join __dirname, 'controllers'

module.exports = deps
