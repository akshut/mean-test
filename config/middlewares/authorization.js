/**
 * Generic require login routing middleware
 */
exports.requiresLogin = function(req, res, next) {
    if (!req.isAuthenticated()) {
        return res.send(401, 'User is not authorized');
    }
    next();
};

/**
 * User authorizations routing middleware
 */
exports.user = {
    hasAuthorization: function(req, res, next) {
        if (req.profile.id != req.user.id) {
            return res.send(401, 'User is not authorized');
        }
        next();
    }
};

//  Room authorizations routing
exports.rooms = {
  hasAuthorization: function(req, res, next) {
    var access;
    for (var room in req.user.access) {
      if(room == req.dr) {
        access = true;
      }
    }
    if(!access) {
      return res.send("you do not have access to: " + req.dr);
    }
    next();
  }
};
