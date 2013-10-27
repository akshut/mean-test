TB = window.TB

window.callDoctor = (sessionId, token, API_KEY, mirror, doctor, cb) ->
  TB.setLogLevel(0)
  publisher = TB.initPublisher API_KEY, mirror
  session = TB.initSession sessionId

  session.connect API_KEY, token

  subscribeToStreams = (streams) ->
    streams.forEach (stream) ->
      if stream.connection.connectionId isnt session.connection.connectionId
        session.subscribe stream

  streamCreatedHandler = (event) ->
    subscribeToStreams event.streams

  sessionConnectedHandler = (event) ->
    subscribeToStreams event.streams
    session.publish(publisher)

    sendName = (name) ->
      session.signal
        type: 'name'
        data: {name}
      , (err) -> console.log err if err

    sendAvatar =  ->
      imgData = publisher.getImgData()
      imgLength = imgData.length
      numOfChunks = Math.ceil(imgLength / 500)

      imgChunks = []

      itr = -500
      imgChunks.push imgData[itr...(itr+500)] while (itr += 500) <= imgLength

      imgData = imgData.slice(0, 500)

      sendChunk = (index) ->
        if index <= imgChunks.length
          session.signal
            type: 'image-chunk'
            data: img: imgChunks[index]
          , (err) -> sendChunk ++index
        else
          session.signal
            type: 'image-end'
            data: msg: "Imgae sent"
          , (err) -> console.log "Done!"

      session.signal
        type: 'image-begin'
        data: msg: "Begin image transition"
        , (err) -> sendChunk 0


    cb sendAvatar, sendName

  session.addEventListener("sessionConnected", sessionConnectedHandler)
  session.addEventListener("streamCreated", streamCreatedHandler)
