/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
    async = require('async'),
    Room = mongoose.model('Room'),
    _ = require('underscore');


// Opentok stuffs

var OpenTokLibrary = require('opentok');
var OTKEY = 36591572;
var OTSECRET = process.env.APIKEY2;
var OpenTokObject = new OpenTokLibrary.OpenTokSDK(OTKEY, OTSECRET);

/**
 * Create a room
 */
exports.create = function(req, res) {

    OpenTokObject.createSession(null, {'p2p.preference':'enabled'}, function (sessionId) {
      sendDrClarkResponse(sessionId, res, req);
    });

};

// Delete a room
exports.delete = function (req, res) {
    Room.remove({_id: req.params._id}, function (err) {
      if(!err) {
        console.log('no delete room error');
        res.json(true);
      } else {
        console.log('delete room error');
        res.json(false);
      }
    });
};

function sendDrClarkResponse(sessionId, res, req) {
    token = OpenTokObject.generateToken({ session_id:sessionId, role:"publisher", connection_data: sessionId});
    data = {dr:req.params.room, sessionId:sessionId, token:token, apiKey:OTKEY};
    var room = new Room(data);
    room.user = req.user;
    room.save();
    res.jsonp(room);
    console.log("Post added: " + data.dr, data.sessionId, data.token, data.apiKey);
}

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