function WaitingController($scope, $routeParams, $location, Global, Rooms, $http) {
    $scope.global = Global;

    $scope.find = function(query) {
        Rooms.query(query, function(rooms) {
            $scope.rooms = rooms;
        });
    };

    $scope.connect = function (obj) {
        startSession(obj.sessionId, 36591572, obj.token);
    };

    $scope.delete = function (obj) {
        $http.delete('/api/' + obj._id).success(function (data) {
            $scope.find();
        });
    };

    TB.setLogLevel(TB.DEBUG);

    var session;

    function startSession (sessionId, apiKey, token) {
      session = TB.initSession(sessionId);

      session.addEventListener("sessionConnected", sessionConnectedHandler);
      session.addEventListener("streamCreated", streamCreatedHandler);

      session.connect(apiKey, token);
      
    }

    function sessionConnectedHandler (event) {
      subscribeToStreams(event.streams);
    }

    function subscribeToStreams(streams) {
      for (var i = 0; i < streams.length; i++) {
        var stream = streams[i];
        if (stream.connection.connectionId != session.connection.connectionId) {
          session.subscribe(stream);
        }
      }
    }

    function streamCreatedHandler(event) {
      subscribeToStreams(event.streams);
    }

}