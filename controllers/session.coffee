module.exports = (activeSessions, Session) ->

  open: (req, res, next) ->
    _id = req.param 'id'

    Session.findOne {_id}, (err, session) ->
      return next err if err
      return next new Error "No session with that id #{_id}" if not session

      activeSessions.addSession session, (err) ->
        return next err if err

      req.on 'close', ->
        activeSessions.removeSession session, (err) -> console.log err if err
