TB = window.TB

window.callDoctor = (sessionId, token, API_KEY) ->
  session = TB.initSession sessionId

  session.connect API_KEY, token

  subscribeToStreams = (streams) ->
    streams.forEach (stream) ->
      session.subscribe stream if stream.connection.connectionId isnt session.connection.connectionId

  streamCreatedHandler = (event) ->
    subscribeToStreams event.streams

  sessionConnectedHandler = (event) ->
    subscribeToStreams event.streams
    session.publish()

  session.addEventListener("sessionConnected", sessionConnectedHandler)
  session.addEventListener("streamCreated", streamCreatedHandler)
