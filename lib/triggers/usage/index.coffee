'use strict'

# Module dependencies.

util    = require 'util'
cron    = require 'cron'
Trigger = require '../../helpers/trigger'


noop = () ->



class DateTimeTrigger extends Trigger
  constructor: () ->
    super()
    @name = 'usage'
  validate: (data, done) ->
    done = done || noop;

    process.nextTick () ->
      done null

module.exports = exports = DateTimeTrigger;
