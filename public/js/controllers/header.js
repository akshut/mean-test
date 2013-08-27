function HeaderController($scope, $location, Global) {
    $scope.global = Global;
    $scope.menu = [{
        "title": "My Waiting Room",
        "link": "waiting"
    }, {
        "title": "Quick Meeting",
        "link": "waiting/create"
    }];

    $scope.init = function() {

    };
}