function WaitingController($scope, $routeParams, $location, Global, Rooms) {
    $scope.global = Global;

    $scope.find = function(query) {
        Rooms.query(query, function(rooms) {
            $scope.rooms = rooms;
        });
    };

    // $scope.rooms = [{"streamId":"1931138488","id":"1931138488","connection":{"connectionId":"3a847919-16dc-4587-b82a-0da7947aa017","id":"3a847919-16dc-4587-b82a-0da7947aa017","creationTime":null,"data":"1_MX4zNjU5MTU3Mn5-V2VkIEF1ZyAwNyAxNTozNDo1MiBQRFQgMjAxM34wLjA3ODIzMDh-","capabilities":{"supportsWebRTC":true},"quality":null},"name":"","type":"WebRTC","creationTime":1375914901080,"hasAudio":true,"hasVideo":true,"orientation":{"width":640,"height":480,"videoOrientation":"OTVideoOrientationRotatedNormal"},"videoDimensions":{"width":640,"height":480},"publisherId":"edaaca3e-6c99-42a1-9a8f-4a732de11ac5"}, {"streamId":"1931138488","id":"1931138488","connection":{"connectionId":"3a847919-16dc-4587-b82a-0da7947aa017","id":"3a847919-16dc-4587-b82a-0da7947aa017","creationTime":null,"data":"1_MX4zNjU5MTU3Mn5-V2VkIEF1ZyAwNyAxNTozNDo1MiBQRFQgMjAxM34wLjA3ODIzMDh-","capabilities":{"supportsWebRTC":true},"quality":null},"name":"","type":"WebRTC","creationTime":1375914901080,"hasAudio":true,"hasVideo":true,"orientation":{"width":640,"height":480,"videoOrientation":"OTVideoOrientationRotatedNormal"},"videoDimensions":{"width":640,"height":480},"publisherId":"edaaca3e-6c99-42a1-9a8f-4a732de11ac5"}];
    $scope.alert = function (thing) {
        alert("you pressed " + thing.streamId);
    };
}