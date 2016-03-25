'use strict';

mongoose = require 'mongoose'

Schema = mongoose.Schema

UserSchema = new Schema
  name: String
  email:
    type: String
    lowercase: true
  role:
    type: String
    default: 'user'
  hashedPassword: String
  provider: String
  salt: String
  facebook: {}
  encored: {}
  github: {}
  accessToken: String
  refreshToken: String


mongoose.model 'User', UserSchema

module.exports = exports = UserSchema
