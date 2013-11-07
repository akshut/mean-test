path     = require 'path'
deps     = require('dependable').container()
mongoose = require 'mongoose'

# Constants
if process.env.DB_URL
  MONGODB_URL = process.env.DB_URL
else if process.env.MONGOLAB_URI
  MONGODB_URL = "#{process.env.MONGOLAB_URI}/doxyme"
else
  MONGODB_URL= "mongodb://localhost/doxyme"

deps.register 'ENV'        , (process.env.NODE_ENV   || 'development')
deps.register 'DB_URL'     , MONGODB_URL
deps.register 'SALT'       , (process.env.SALT       || 'd417868719d0077ecb1f9830658030cb')
deps.register 'PORT'       , (process.env.PORT       || 3000)
deps.register 'API_KEY'    , (process.env.API_KEY    || 36591572)
deps.register 'SECRET'     , (process.env.SECRET     || process.env.APIKEY2)
deps.register 'REDIS_URL'  , (process.env.REDIS_URL  || process.env.REDISTOGO_URL || 'localhost')
deps.register 'REDIS_PORT' , (process.env.REDIS_PORT || 6379)
deps.register 'REDIS_DB'   , (process.env.REDIS_DB   || 1)
deps.register 'REDIS_PASS' , (process.env.REDIS_PASS || '')

deps.register 'db', mongoose.connect(deps.get('DB_URL'))

deps.load path.join __dirname, 'lib'
deps.load path.join __dirname, 'models'
deps.load path.join __dirname, 'controllers'

module.exports = deps
