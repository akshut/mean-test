TB = window.TB

window.callDoctor = (sessionId, token, API_KEY, mirror, theirPublisherDiv, cb) ->
  TB.setLogLevel(0)
  publisher = TB.initPublisher API_KEY, mirror
  session = TB.initSession sessionId

  session.connect API_KEY, token

  subscribeToStreams = (streams) ->
    streams.forEach (stream) ->
      if stream.connection.connectionId isnt session.connection.connectionId
        div = document.createElement("div")
        div.setAttribute "class", "patient-video"
        div.setAttribute "id", "stream" + session._id
        dr = document.getElementById("theirPublisherDiv")
        dr.appendChild div
        session.subscribe stream, div, width: "100%", height: "100%"

  streamCreatedHandler = (event) ->
    subscribeToStreams event.streams
    $('#promptArrow').remove()

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

      sendChunk = (index) ->
        if index <= imgChunks.length
          session.signal
            type: 'image-chunk'
            data: img: imgChunks[index], index: index
          , (err) ->
            return console.error err if err
            sendChunk ++index
        else
          session.signal
            type: 'image-end'
            data: msg: "Imgae sent"
          , (err) ->
            return console.error err if err
            console.log "Done!"

      session.signal
        type: 'image-begin'
        data: msg: "Begin image transition"
        , (err) ->
          return console.error err if err
          sendChunk 0


    cb sendAvatar, sendName, session

  session.on("sessionConnected", sessionConnectedHandler)
  session.on("streamCreated", streamCreatedHandler)
