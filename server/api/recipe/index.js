'use strict';

var express = require('express');
var controller = require('./recipe.controller');
var config = require('../../config/environment');

var router = express.Router();

router.get('/recipes', auth.hasRole('user'), controller.getRecipes);
router.post('/recipes', auth.hasRole('user'), controller.createRecipe);

module.exports = router;
