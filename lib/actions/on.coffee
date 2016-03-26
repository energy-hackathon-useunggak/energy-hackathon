'use strict'

# Module dependencies.
debug     = require 'debug'
request   = require 'request'
mongoose  = require 'mongoose'
User      = mongoose.model 'User'


log       = debug 'energy-hackathon:action:on'

module.exports = exports = (data) ->
  log 'Got request', data
  return unless data && data.user && data.uuid

  log 'request data valid... calling api...'

  User.findById data.user
  .exec (e, user) ->
    return console.error(e.stack) if e

    request
      method: 'PUT'
      url: "https://api.encoredtech.com/1.2/devices/#{data.uuid}/relay"
      headers:
        'Authorization': "Bearer #{user.accessToken}"
      qs:
        mode: 'ON'
      json: true
    , (e, res, body) ->
      return done(e) if e

      console.log 'on completed, payload: ', body
