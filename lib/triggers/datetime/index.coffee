'use strict'

# Module dependencies.

util    = require 'util'
cron    = require 'cron'
Trigger = require '../../helpers/trigger'


noop = () ->



class DateTimeTrigger extends Trigger
  constructor: () ->
    @super()
    @name = 'datetime'
  validate: (data, done) ->
    done = done || noop;

    return done(new Trigger.ValidationError('`cron` string should be specified.')) unless data && data.cron

    try
      new cron.CronJob data.cron, noop
    catch e
      return done(new Trigger.ValidationError('`cron` is not valid cron format.'))
    process.nextTick () ->
      done null

module.exports = exports = DateTimeTrigger;
