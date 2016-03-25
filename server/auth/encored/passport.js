var passport = require('passport');
var EncoredEnertalkStrategy = require('passport-encored-enertalk').Strategy;

/**
 * Configurations.
 */
var
  ENCORED_ENERTALK_CLIENT_ID = 'bW9veW91bEBnbWFpbC5jb21fcGFzc3BvcnQtZW5jb3JlZC1lbmVydGFsay1leGFtcGxl',
  ENCORED_ENERTALK_CLIENT_SERCRET = 'cy1em4tw5qg8p38qo9dy0c834h6xg96l9td4ds1';

exports.setup = function (User, config) {
  passport.use(new EncoredEnertalkStrategy({
      clientID: ENCORED_ENERTALK_CLIENT_ID,
      clientSecret: ENCORED_ENERTALK_CLIENT_SERCRET,
      callbackURL: 'http://127.0.0.1:9000/auth/encored-enertalk/callback'
    },
    function(accessToken, refreshToken, profile, done) {
      User.findOne({
          'encored': profile.id
        },
        function(err, user) {
          if (err) {
            return done(err);
          }
          if (!user) {
            user = new User({
              name: "test",
              email: profile.email,
              role: 'user',
              provider: 'encored',
              encored: profile._json.userId
            });
            user.save(function(err) {
              if (err) return done(err);
              done(err, user);
            });
          } else {
            return done(err, user);
          }
        })
    }
  ));
};
