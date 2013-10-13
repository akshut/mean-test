serr = require 'std-error'

module.exports = (paramsValid, Room, API_KEY, SECRET) ->

  create: (req, res, next) ->
    if not req.param('user')
      return next serr.BadParameter 'Missing user field'

    handleRoom = (err, room) ->
      return next err if err
      res.json room

    name = req.param 'name'

    if name
      Room.createRoomFromName req.body, handleRoom
    else
      Room.createRandomRoom req.body, handleRoom

  joinRoomByName: (req, res, next) ->
    name = req.param 'roomName'
    Room.joinByName name, (err, data) ->
      return next err if err

      res.render 'rooms/room', data

  eventsForRoom: (req, res, next) ->
    slug = req.param('roomName').toLowerCase()

    Room.findOne {slug}, (err, room) ->
      return next err if err
      if not room
        return next new Error "The room named #{name} does not exist"

      res.writeHead 200,
        'Content-Type': 'text/event-stream'
        'Cache-Control': 'no-cache'
        'Connection': 'keep-alive'

      res.write "\n\n"

      interval = setInterval ->
        res.write "data: lol\n\n"
        console.log "HEY"
      , 3000

      req.on 'close', -> clearInterval interval
