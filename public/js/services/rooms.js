//Rooms service used for rooms REST endpoint
window.app.factory("Rooms", function($resource) {
    return $resource('rooms/:roomId', {
        roomId: '@_id'
    }, {
        update: {
            method: 'PUT'
        }
    });
});