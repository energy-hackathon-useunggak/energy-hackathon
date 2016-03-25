'use strict';

var express = require('express');
var controller = require('./recipe.controller');
var config = require('../../config/environment');
var auth = require('../../auth/auth.service');

var router = express.Router();

router.get('/', auth.hasRole('user'), controller.index);
router.post('/', auth.hasRole('user'), controller.create);

module.exports = router;
