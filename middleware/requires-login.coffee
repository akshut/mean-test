module.exports = (req, res, next) ->
  if not req.isAuthenticated()
    return res.send 401, 'User is not authorized'

  next()
