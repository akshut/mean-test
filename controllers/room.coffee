serr = require 'std-error'

module.exports = (paramsValid, Room, API_KEY, SECRET, activeSessions) ->

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

  openSessions: (req, res, next) ->
    slug = req.param('roomSlug').toLowerCase()

    count = 0

    interval = setInterval ->
      activeSessions.getSessionsForRoom slug, (err, sessions) ->
        if not sessions and count < 1
          count++
          console.log count, "IF not sessions and count"
        else
          res.json {sessions, err}
          count = 0
          console.log sessions, count, "else!!!!!!"
    , 3000

    req.on 'close', -> clearInterval interval
