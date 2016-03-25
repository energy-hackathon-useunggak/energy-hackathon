'use strict'

passport      = require 'passport'
middleware    = require './middleware'
index         = require './controllers/index'
devices = require './controllers/device'

module.exports = (app, io) ->
  app.get('/auth/encored-enertalk', passport.authenticate('encored-enertalk'))
  app.get('/auth/encored-enertalk/callback',
    passport.authenticate('encored-enertalk', { failureRedirect: '/' }),
    (req, res) ->
      res.redirect('/')
  )
  app.get('/api/devices', middleware.auth, devices.getDevices);
  app.get('/api/recipies', middleware.auth, controller.index);
  app.post('/api/recipies', middleware.auth, controller.create);

  app.route('/api/*')
    .get (req, res) ->
      res.sendStatus(404)

  app.route('/*')
    .get(index.index)
