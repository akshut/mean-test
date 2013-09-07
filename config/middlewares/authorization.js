/**
 * Generic require login routing middleware
 */
exports.requiresLogin = function(req, res, next) {
    if (!req.isAuthenticated()) {
        return res.redirect('/signin');
    }
    next();
};

/**
 * User authorizations routing middleware
 */
exports.user = {
    hasAuthorization: function(req, res, next) {
        if (req.profile.id != req.user.id) {
            return res.redirect('/users/' + req.profile.id);
        }
        next();
    }
};

/**
 * Article authorizations routing middleware
 */
exports.article = {
    hasAuthorization: function(req, res, next) {
        if (req.article.user.id != req.user.id) {
            return res.redirect('/articles/' + req.article.id);
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
