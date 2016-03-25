'use strict';

var passport = require('passport');
var oauth2Request = require('../../lib/oauth2-request');



/**
 * Get devices which associated with current user.
 */
exports.getDevices = function(req, res) {
  oauth2Request(req.user, {
    method: 'GET',
    url: 'https://api.encoredtech.com/1.2/devices/list',
    json: true
  }, function(e, body, res2) {
    if (e) {
      console.error(e.stack);
      return res2.sendStatus(500);
    }
    res.send(body);
  });
};
