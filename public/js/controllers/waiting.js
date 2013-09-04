function WaitingController($scope, $routeParams, $location, Global, Rooms, $http) {
    $scope.global = Global;

    $scope.find = function(query) {
        Rooms.query(query, function(rooms) {
            $scope.rooms = rooms;
        });
    };

    $scope.connect = function (obj, thing) {
        // check to see if Dr is publish then publish
        // if(!ppublisher) { publish(); }
        // disconnect from any current session
        if(session) {
            session.disconnect();
        }
        startSession(obj.sessionId, 36591572, obj.token);
    };

    $scope.delete = function (obj) {
        if (session) {
            session.disconnect();
        }
        $http.delete('/api/' + obj._id).success(function (data) {
            $scope.find();
        });
    };

    // auto connect to rooms in Database

    // var myVar=setInterval(function(){$scope.test();},1000 * 3);
    setInterval(function () {
        $scope.$apply(function () {
            $scope.find();
        });
    }, 1000 * 10);

    // Is the whole window.setTimeout.. wrong with angular?
    // var timeoutConnect = function (i, object) {
    //   window.setTimeout(function () {
    //     startSession(object.sessionId, 36591572, object.token);
    //   }, i * 3000);
    // };


    // $scope.auto = function () {
    //     console.log("was called");
    //     $http.get('/api').success(function (data) {
    //         $scope.rooms = data;
    //         for (var i = 0; i < data.length; i++) {
    //           timeoutConnect(i, data[i]);
    //         }
    //     });
    // };


    // Tokbox session and connection code. Probably should get rid of the session global?
    // TB.setLogLevel(TB.DEBUG);

    // Publishing logic

    var ppublisher;

    // function connectToStream () {
    //   session.publish(ppublisher);
    // }

    // function publish () {
    //   ppublisher = TB.initPublisher(36591572, 'myPublisherDiv');
    // }

    // end of publishing logic

    var session;

    function startSession (sessionId, apiKey, token) {
      session = TB.initSession(sessionId);

      session.addEventListener("sessionConnected", sessionConnectedHandler);
      session.addEventListener("streamCreated", streamCreatedHandler);
      session.addEventListener("sessionDisconnected", sessionDisconnectHandler);
      session.connect(apiKey, token);

    }

    // disconnect handler
    function sessionDisconnectHandler (event) {
        console.log(event);
    }

    function sessionConnectedHandler (event) {
        ppublisher = TB.initPublisher(36591572, 'myPublisherDiv', {height: "135px", width: "180px"});
        session.publish(ppublisher);
        subscribeToStreams(event.streams);
    }

    function subscribeToStreams(streams) {
      for (var i = 0; i < streams.length; i++) {
        var stream = streams[i];
        if (stream.connection.connectionId == session.connection.connectionId) {
          return;
        }
        // Create the div to put the subscriber element in to
        var div = document.createElement('div');
        div.setAttribute('id', 'stream' + stream.streamId);
        var streamsContainer = document.getElementById('theirPublisherDiv');
        streamsContainer.appendChild(div);

        // Subscribe to the stream
        session.subscribe(stream, div.id, {height: '100%', width: '100%'});
      }

    }

    function streamCreatedHandler(event) {
      subscribeToStreams(event.streams);
    }

}
