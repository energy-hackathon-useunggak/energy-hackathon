'use strict';

/**
 * Module dependencies.
 */

var
  _       = require('underscore'),
  request = require('request');


var
  // @todo Migrate var values into .env file
  ENCORED_ENERTALK_CLIENT_ID = 'bW9veW91bEBnbWFpbC5jb21fcGFzc3BvcnQtZW5jb3JlZC1lbmVydGFsay1leGFtcGxl',
  ENCORED_ENERTALK_CLIENT_SERCRET = 'cy1em4tw5qg8p38qo9dy0c834h6xg96l9td4ds1',
  ENCORED_ENERTALK_TOKEN_ENDPOINT = 'https://enertalk-auth.encoredtech.com/token',
  noop = function(){};

/**
 * @params {User}     user      User Model
 * @params {Object}   options   options will be passed to `request` module.
 * @return {request}
 */
module.exports = exports = function(user, options, done) {
  var
    accessToken = user.accessToken,
    refreshToken = user.refreshToken,

  _options = options || {};
  _options.headers = _.extend(_options.headers || {}, {
    Authorization: 'Bearer ' + accessToken
  });

  done = done || noop;

  return request(_options, function(e, res, body) {
    if (e) { return done(e); }


    if (res.statusCode !== 403) {
      return done(null, body, res);
    }

    // 403 Unauthorized
    // Maybe access token expired? try to renew token
    var basicAuth = (new Buffer(ENCORED_ENERTALK_CLIENT_ID + ':' + ENCORED_ENERTALK_CLIENT_SERCRET)).toString('base64');

    request({
      method: 'POST',
      url: ENCORED_ENERTALK_TOKEN_ENDPOINT,
      headers: {
        Authorization: 'Basic ' + basicAuth
      },
      form: {
        grant_type: 'refresh_token',
        refresh_token: refreshToken
      }
    }, function(e, res, body) {
      if (e) { return done(e); }

      if (res.statusCode !== 200) {
        return done(new Error('Expired token'));
      }

      if (typeof body === 'string') {
        try {
          body = JSON.parse(body);
        } catch (e) {
          return done(e);
        }
      }
      _.extend(_options, {
        Authorization: 'Bearer' + body.accessToken
      });

      request(_options, function(e, res, _body) {
        if (e) { return done(e); }

        done(null, _body, res);

        _.extend(user, {
          accessToken: body.accessToken,
          refreshToken: body.refreshToken,
        });

        user.save(function(e) {
          console.error(e.stack);
        })
      });
    });
  });
};
