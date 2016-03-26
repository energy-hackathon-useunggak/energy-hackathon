'use strict'

# Module dependencies.
debug       = require 'debug'
cron        = require 'cron'
request     = require 'request'
mongoose    = require 'mongoose'


# Module specific configurations.
log         = debug 'energy-hackathon:dispatcher:usage'

process.on 'message', (data) ->
  if data.event is 'subscribe'
    User = mongoose.model 'User'
    Device = mongoose.model 'Device'

    log 'got subscribe request', data
    user = data && data.data && data.data.user

    return unless user

    log 'Got user!', user

    User.findById user
    .exec (e, user) ->
      return console.error(e.stack) if e
      return console.error('unknown user', user) unless user

      Device.findById data.data.usage.device
      .exec (e, sourceDevice) ->
        return console.error(e.stack) if e
        return console.error('unknown device', data.data.usage) unless sourceDevice

        queue = [];
        maxSize = data.data.usage.minute

        job = new cron.CronJob '0 * * * * *', () ->
          request
            method: 'GET'
            headers:
              'Authorization': "Bearer #{user.accessToken}"
            url: "https://api.encoredtech.com/1.2/devices/#{sourceDevice.uuid}/realtimeUsage"
            json: true
          , (e, res, body) ->
              return console.error(e) if e

              log 'Got API response from server (status: %d): ', res.statusCode, body

              queue.shift() if queue.push(body.activePower) > data.data.usage.minute
              log 'queue: ', queue

              if queue.length is maxSize
                avg = queue.reduce(((memo, x) -> memo + x), 0) / queue.length / 1000

                log 'avg: %d / value: %d', avg, data.data.Usage.value

                willTrigger = (data.data.condition is 'over' and avg >= data.data.value) ||
                 (data.data.condition is 'under' and avg < data.data.value)

                if willTrigger
                  process.send
                    event: 'publish'
                    data: data.data
        , null, true


db = mongoose.connect process.env.MONGO_URL,
  options:
      db:
        safe: true
, (e) ->
  throw e if e

  mongoose.set 'debug', process.env.NODE_ENV is "development"

  # Bootstrap models
  require '../../models/user'
  require '../../models/device'

  process.send
    event: 'online'
