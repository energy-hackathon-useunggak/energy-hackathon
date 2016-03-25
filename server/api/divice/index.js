'use strict';

var express = require('express');
var controller = require('./device.controller');
var config = require('../../config/environment');

var router = express.Router();

router.get('/devices', auth.hasRole('user'), controller.getDevices);

module.exports = router;
