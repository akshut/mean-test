module.exports = ->

  validateBody = (body, params) ->
    keys = Object.keys body

    bodyIsValid = keys.every (key) -> key in params

    if bodyIsValid isnt true then @missingParams = params.filter (param) ->
      if not (param in keys) then param

    bodyIsValid
