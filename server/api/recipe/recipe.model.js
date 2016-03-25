'use strict';

var mongoose = require('mongoose');
var RecipeSchema = mongoose.Schema;


var RecipeSchema = new Schema({
  user: {type: mongoose.Schema.ObjectId,ref: 'User'},
  device: {type: mongoose.Schema.ObjectId,ref: 'Device'},
  action: {type: String, enum: ["On", "Off", "Toggle"] },
  Date: String,
  Usage: {
    minute: Number,
    Under: Number,
    Over: Number
  }
});

module.exports = mongoose.model('Recipe', Schema);
