redis = require 'redis'
client = redis.createClient()
client.flushdb()

module.exports = ->

  addSession: (session, cb) ->
    client.hset session.roomSlug, session._id , JSON.stringify(session)

  removeSession: (session, cb) ->
    client.hdel session.roomSlug, session._id

  getSessionsForRoom: (room, cb) ->
    client.hgetall room, (err, sessions) ->
      cb err, sessions or []
