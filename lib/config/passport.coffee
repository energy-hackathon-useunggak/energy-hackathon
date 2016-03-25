"use strict"

mongoose                  = require 'mongoose'
_                         = require 'underscore'
User                      = mongoose.model 'User'
passport                  = require 'passport'
EncoredEnertalkStrategy   = require('passport-encored-enertalk').Strategy

###
Passport configuration
###
passport.serializeUser (user, done) ->
  done null, (if user._id then user._id.toString() else user.id)

passport.deserializeUser (id, done) ->
  User.findById id
  .exec (err, user) ->
    done err, user


passport.use new EncoredEnertalkStrategy
  clientID: process.env.ENCORED_ENERTALK_CLIENT_ID
  clientSecret: process.env.ENCORED_ENERTALK_CLIENT_SERCRET
  callbackURL: process.env.ENCORED_ENERTALK_CALLBACK_URL
, (accessToken, refreshToken, profile, done) ->
  User.findOne
    'encored.userId': profile.id
  .exec (e, user) ->
    return done(e) if e

    if (!user)
      user = new User
        name: profile.displayName
        email: profile.email
        role: 'user'
        provider: 'encored'
        encored: profile._json
        accessToken: accessToken
        refreshToken: refreshToken
    else
      _.extend user,
        accessToken: accessToken
        refreshToken: refreshToken

    user.save (e) ->
      return done(e) if e
      done null, user

module.exports = passport
