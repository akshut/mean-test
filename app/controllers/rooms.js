/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
    async = require('async'),
    Room = mongoose.model('Room'),
    _ = require('underscore');

/**
 * Create a room
 */
exports.create = function(req, res) {
    var room = new Room(req.body);

    room.user = req.user;
    room.save();
    res.jsonp(room);
};

/**
 * List of Articles
 */
exports.all = function(req, res) {
    Room.find().sort('-created').populate('user').exec(function(err, rooms) {
        if (err) {
            res.render('error', {
                status: 500
            });
        } else {
            res.jsonp(rooms);
        }
    });
};