/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
    env = process.env.NODE_ENV || 'development',
    config = require('../../config/config')[env],
    Schema = mongoose.Schema;


/**
 * Room Schema
 */
var RoomSchema = new Schema({
    created: {
        type: Date,
        default: Date.now
    },
    dr: {
        type: String,
        default: 'DrX',
        trim: true
    },
    sessionId: {
        type: String,
        default: '123456789',
        trim: true
    },
    user: {
        type: Schema.ObjectId,
        ref: 'User'
    },
    token: {
        type: String,
        default: 'asdf1234'
    }
});



mongoose.model('Room', RoomSchema);