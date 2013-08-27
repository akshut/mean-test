function HeaderController($scope, $location, Global) {
    $scope.global = Global;
    $scope.menu = [{
        "title": "My Waiting Room",
        "link": "rooms/waiting"
    }, {
        "title": "Quick Meeting",
        "link": "rooms/create"
    }];

    $scope.init = function() {

    };
}