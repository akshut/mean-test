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

function sendDrClarkResponse(sessionId, res, req) {
    token = OpenTokObject.generateToken({ session_id:sessionId, role:"publisher", connection_data: sessionId});
    data = {dr: req.path.substring(1), sessionId:sessionId, token:token, apiKey:OTKEY};
    var room = new Room(data);
    room.user = req.user;
    room.save();
    console.log("Post added: " + data.dr, data.sessionId, data.token, data.apiKey);
    res.render('doctors/DrClark', data);
}


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


/**
 * Find room by user.rooms array, cheating with [0] and it is case sensitive
 * Updated Room schema so dr: is always lowercase
 * !!Remember to give the user the right permission!
 * e.g. req.user.rooms[0] == 'drexample'
 */
exports.room = function(req, res, next) {
  Room.find({dr: req.user.rooms[0]}).exec(function(err, result){
    if(err) {
      res.jsonp(err);
    } else {
      res.jsonp(result);
    }
  });
};

/**
 * List of Rooms
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

