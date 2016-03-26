'use strict'

# Module dependencies.
request   = require 'request'
mongoose  = require 'mongoose'
User      = mongoose.model 'User'



module.exports = exports = (data) ->
  return unless data && data.user && data.uuid

  User.findById data.user
  .exec (e, user) ->
    return console.error(e.stack) if e

    request
      method: 'GET'
      url: "https://api.encoredtech.com/1.2/devices/#{data.uuid}/relay",
      headers:
        'Authorization': "Bearer #{user.accessToken}"
      json: true
    , (e, res, body) ->
      return done(e) if e

      status = body && body.status

      request
        method: 'PUT'
        url: "https://api.encoredtech.com/1.2/devices/#{data.uuid}/relay"
        headers:
          'Authorization': "Bearer #{user.accessToken}"
        qs:
          mode: if status is 'ON' then 'OFF' else 'ON'
        json: true
      , (e, res, body) ->
        return done(e) if e

        console.log 'Toggle completed, payload: ', body
