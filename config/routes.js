var async = require('async');

module.exports = function(app, passport, auth) {
    //User Routes
    var users = require('../app/controllers/users');
    app.get('/signin', users.signin);

    // This is temporary for testing, we will want a real way to sign up ===
    app.get('/e4125f1c0b5e409fc667a7b3b34add9b3a1357ff', users.signup);
    // =====
    app.get('/signout', users.signout);

    //Setting up the users api
    app.post('/users', users.create);

    app.post('/users/session', passport.authenticate('local', {
        failureRedirect: '/signin',
        failureFlash: 'Invalid email or password.'
    }), users.session);

    app.get('/users/me', users.me);
    app.get('/users/:userId', users.show);

    //Finish with setting up the userId param
    app.param('userId', users.user);


    // Rooms Routes
    var rooms = require('../app/controllers/rooms');
    app.get('/rooms', auth.requiresLogin,  rooms.room);

    // To Be Deleted used for testing ========
    app.get('/drclark', rooms.create);
    // =========


    // Rooms Api
    // I use this in the dashboard's patient list to delete the room
    app.delete('/api/:_id', rooms.delete);


    //Home route
    var index = require('../app/controllers/index');
    app.get('/', index.render);

};
