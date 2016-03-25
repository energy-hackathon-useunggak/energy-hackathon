'use strict'

passport      = require 'passport'
middleware    = require './middleware'
index         = require './controllers/index'

module.exports = (app, io) ->
  app.get('/auth/encored-enertalk', passport.authenticate('encored-enertalk'))
  app.get('/auth/encored-enertalk/callback',
    passport.authenticate('encored-enertalk', { failureRedirect: '/' }),
    (req, res) ->
      res.redirect('/')
  )

  app.route('/*')
    .get(index.index)
