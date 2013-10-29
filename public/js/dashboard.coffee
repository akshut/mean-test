window.listenForSessionsOnRoom = (room) ->

  TB.setLogLevel(0)
  if room.sessions
    openSessionIds = Object.keys room.sessions
  else
    openSessionIds = []

  $room = $(".room##{room.slug}")
  $sessionList = $room.find '.session-list'

  listener = new EventSource "/#{room.slug}/sessions"

  addSession = (id, session) ->
    openSessionIds.push id
    $sessionList.append templatizer.dashboard.session.session session
    console.log "Added a session bro"

  removeSession = (id) ->
    index = openSessionIds.indexOf id
    openSessionIds.splice index, 1
    $sessionList.find("##{id}").remove()
    console.log "Removed a session bro"


  listener.addEventListener 'message', (message) ->

    data = JSON.parse message.data

    if data.sessions
      sessionIds = Object.keys data.sessions
    else
      sessionIds = []

    newSessionIds = sessionIds.filter (id) -> id not in openSessionIds
    oldSessionIds = openSessionIds.filter (id) -> id not in sessionIds

    if newSessionIds.length
      newSessionIds.forEach (id) -> addSession id, data.sessions[id]

    if oldSessionIds.length
      oldSessionIds.forEach (id) -> removeSession id
