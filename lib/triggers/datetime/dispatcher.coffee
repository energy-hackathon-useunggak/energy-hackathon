'use strict'

# Module dependencies.
cron = require 'cron'

# Module specific configurations.

process.on 'message', (data) ->
  if data.event is 'subscribe'
    console.log 'cron string: ', data.data.cron
    job = new cron.CronJob data.data.cron, () ->
      console.log 'tick'
      process.send
        event: 'publish'
        type: 'datetime'
        data: data.data
    , null, true

process.send
  event: 'online'
