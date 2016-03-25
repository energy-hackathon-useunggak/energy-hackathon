'use strict'

 # Module dependencies.

_       = require 'underscore'
request = require 'request'


noop = () ->

#  @params {User}     user      User Model
# @params {Object}   options   options will be passed to `request` module.
# @return {request}
module.exports = exports = (user, options, done) ->
  accessToken = user.accessToken
  refreshToken = user.refreshToken

  _options = options || {}
  _options.headers = _.extend _options.headers || {},
    Authorization: 'Bearer ' + accessToken

  done = done || noop

  return request _options, (e, res, body) ->
    return done(e) if e

    return done(null, body, res) if res.statusCode isnt 403

    # 403 Unauthorized
    #  Maybe access token expired? try to renew token
    basicAuth = (new Buffer(process.env.ENCORED_ENERTALK_CLIENT_ID + ':' + process.env.ENCORED_ENERTALK_CLIENT_SERCRET)).toString('base64');

    request
      method: 'POST'
      url: process.env.ENCORED_ENERTALK_TOKEN_ENDPOINT
      headers:
        Authorization: 'Basic ' + basicAuth
      form:
        grant_type: 'refresh_token'
        refresh_token: refreshToken
    , (e, res, body) ->
      return done(e) if e
      return done(new Error('Expired token')) if res.statusCode isnt 200

      if typeof body is 'string'
        try
          body = JSON.parse body
        catch e
          return done(e)

      _.extend _options,
        Authorization: 'Bearer' + body.accessToken

      request _options, (e, res, _body) ->
        return done(e) if e
        done null, _body, res

        _.extend user,
          accessToken: body.accessToken,
          refreshToken: body.refreshToken,

        user.save (e) ->
          console.error(e.stack) if e
