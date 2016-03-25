'use strict';

var User = require('../user/user.model');
var passport = require('passport');
var config = require('../../config/environment');
var jwt = require('jsonwebtoken');



/**
 * Get devices which associated with current user.
 */
exports.getDevices = (req, res) {
  console.log(req.user);
  oauth2Request(req.user, {
    method: 'GET',
    url: 'https://api.encoredtech.com/1.2/devices/list',
    json: true
  }, (e, body, res) => {
    if (e) {
      console.error(e.stack);
      return res.sendStatus(500);
    }

    res.send(body);
  });
};
