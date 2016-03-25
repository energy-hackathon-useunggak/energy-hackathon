'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var DeviceSchema = new Schema({

  name: String,
  user: {type: mongoose.Schema.ObjectId,ref: 'User'},
  model: String,
  uuid: String
});

module.exports = mongoose.model('Device', DeviceSchema);



