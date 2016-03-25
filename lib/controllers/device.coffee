'use strict'

passport = require('passport')
oauth2Request = require('../helpers/oauth2-request')
mongoose = require('mongoose')
Device = mongoose.model('Device')

exports.getDevices = (req, res) ->
  oauth2Request req.user, {method: 'GET', url: 'https://api.encoredtech.com/1.2/devices/list', json: true}, (e, body, res2) ->

    if e
      console.error(e.stack)
      return res2.sendStatus(500)

    for item in body
      await Device.findOne uuid:item.uuid
      .exec defer(err, device)

      if !device
        await Device.create
          user : req.user._id
          model : item.model
          uuid : item.uuid
        ,defer e, model

    await Device.find
      user:req.user._id
    .exec defer err, devices

    res.send(devices)
