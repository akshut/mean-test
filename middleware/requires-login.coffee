module.exports = (req, res, next) ->
  if not req.isAuthenticated()
    console.log "User is not authenticated"
    return res.redirect '/i/signin'

  next()
