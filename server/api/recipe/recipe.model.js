'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var RecipeSchema = new Schema({
  user: {type: mongoose.Schema.ObjectId,ref: 'User'},
  device: {type: mongoose.Schema.ObjectId,ref: 'Device'},
  action: {type: String, enum: ["on", "off", "toggle"] },
  Date: String,
  Usage: {
    device: {type: mongoose.Schema.ObjectId,ref: 'Device'},
    minute: Number,
    calc: {type:String, enum: ["sum", "average"]},
    condition: {type:String, enum: ["under", "over"]},
    value: Number
  },
  type: {type:String, enum:["datetime","usage"]}
});

module.exports = mongoose.model('Recipe', RecipeSchema);
