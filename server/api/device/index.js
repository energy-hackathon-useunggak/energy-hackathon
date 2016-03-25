'use strict';

var express = require('express');
var controller = require('./device.controller');
var config = require('../../config/environment');
var auth = require('../../auth/auth.service');


var router = express.Router();

router.get('/', controller.getDevices);

module.exports = router;
