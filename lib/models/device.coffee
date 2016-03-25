'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

DeviceSchema = new Schema
  name: String
  user:
    type: mongoose.Schema.ObjectId
    ref: 'User'
  model: String
  uuid: String

module.exports = mongoose.model 'Device', DeviceSchema
