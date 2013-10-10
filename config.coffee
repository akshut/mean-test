path     = require 'path'
deps     = require('dependable').container()
mongoose = require 'mongoose'

# Constants
deps.register 'ENV'    , (process.env.NODE_ENV || 'development')
deps.register 'DB_URL' , (process.env.DB_URL   || 'mongodb://localhost/doxyme')
deps.register 'SALT'   , (process.env.SALT     || 'd417868719d0077ecb1f9830658030cb')
deps.register 'PORT'   , (process.env.PORT     || 3000)

deps.register 'db', mongoose.connect(deps.get('DB_URL'))
deps.load path.join __dirname, 'lib'
deps.load path.join __dirname, 'models'
deps.load path.join __dirname, 'controllers'

module.exports = deps
