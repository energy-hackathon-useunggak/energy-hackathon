'use strict'

_               = require 'underscore'
DateTimeTrigger = require './datetime/'
UsageTrigger    = require './usage/'

triggers = Object.create null


triggers.datetime = new DateTimeTrigger()
triggers.usage  = new UsageTrigger()

_.each triggers, (trigger) -> trigger.run()

exports.create = (type, data, done) ->
  trigger = triggers[type]

  return done(new Error('Failed to find specified type')) unless trigger

  trigger.create data, (e) ->
    return done(e) if e

    done null
