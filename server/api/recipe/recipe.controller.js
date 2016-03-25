'use strict';

var Recipe = require('./recipe.model');
var config = require('../../config/environment');

var validationError = function(res, err) {
  return res.status(422).json(err);
};

exports.index = function(req, res) {
  Recipe.find({user:req.user._id}.populate('device'), function (err, recipes) {
    if(err) return res.status(500).send(err);
    res.status(200).json(recipes);
  });
};

exports.create = function (req, res, next) {
  var newRecipe = new Recipe(req.body);
  newRecipe.save(function(err, recipe) {
    if (err)
      return res.status(500).json(err);
    res.status(200).json(recipe);
  });
};

