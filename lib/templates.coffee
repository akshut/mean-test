templatizer = require 'templatizer'
path = require 'path'

templatizer path.join(__dirname, '../views'), path.join(__dirname, '../public/js/templates.js')
