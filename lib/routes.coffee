'use strict'

passport      = require 'passport'
middleware    = require './middleware'
index         = require './controllers/index'
users          = require './controllers/users'
devices       = require './controllers/device'
recipes      = require './controllers/recipes'

module.exports = (app, io) ->
  app.get('/auth/encored-enertalk', passport.authenticate('encored-enertalk'))
  app.get('/auth/encored-enertalk/callback',
    passport.authenticate('encored-enertalk', { failureRedirect: '/?failed' }),
    (req, res) ->
      res.redirect('/')
  )
  app.get('/api/devices', middleware.auth, devices.getDevices)
  app.get('/api/recipes', middleware.auth, recipes.index)
  app.post('/api/recipes', middleware.auth, recipes.create)
  app.get('/api/users/me', middleware.auth, users.me)

  app.route('/api/*')
    .get (req, res) ->
      res.sendStatus(404)

  app.route('/*')
    .get(index.index)
