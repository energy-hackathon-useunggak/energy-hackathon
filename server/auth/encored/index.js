'use strict';

var express = require('express');
var passport = require('passport');
var auth = require('../auth.service');

var router = express.Router();

router
  .get('/', passport.authenticate('encored-enertalk'))

  .get('/callback',
    passport.authenticate('encored-enertalk', { failureRedirect: '/' }),
    auth.setTokenCookie);
module.exports = router;
