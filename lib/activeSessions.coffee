redis = require 'redis'

module.exports = (REDIS_PORT, REDIS_HOST, REDIS_PASS)->

  client = redis.createClient(REDIS_PORT, REDIS_HOST)
  client.auth REDIS_PASS, (err) ->
    console.log err if err
    client.flushdb()

  addSession: (session, cb) ->
    client.hset session.roomSlug, session._id , JSON.stringify(session)

  removeSession: (session, cb) ->
    client.hdel session.roomSlug, session._id

  getSessionsForRoom: (room, cb) ->
    client.hgetall room, (err, sessions) ->
      return cb err if err
      if sessions
        Object.keys(sessions).forEach (session) ->
          sessions[session] = JSON.parse(sessions[session])

      cb null, sessions
