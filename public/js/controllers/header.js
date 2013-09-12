angular.module('mean.system').controller('HeaderController', ['$scope', 'Global', function ($scope, Global) {
    $scope.global = Global;

    $scope.menu = [{
        "title": "My Waiting Room",
        "link": "rooms/waiting"
    }, {
        "title": "Quick Meeting",
        "link": "rooms/create"
    }];
}]);
