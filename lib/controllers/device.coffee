'use strict'

passport = require('passport')
oauth2Request = require('../helpers/oauth2-request')
mongoose = require('mongoose')
Device = mongoose.model('Device')

exports.getDevices = (req, res) ->
  oauth2Request req.user, {method: 'GET', url: 'https://api.encoredtech.com/1.2/devices/list', json: true}, (e, body, res2) ->
    console.log body

    if e
      console.error(e.stack)
      return res2.sendStatus(500)

    for item in body
      Device.find uuid:body.uuid, (err, device) ->
        if !device
          device = new Device
          device.user = req.user._id
          device.model = item.model
          device.uuid = item.uuid
          await device.save defer e, model

    await Device.find
      user:req.user._id
    .exec defer err, devices

    res.send(devices)
