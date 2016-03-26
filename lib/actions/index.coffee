'use strict'

debug = require 'debug'
log   = debug 'energy-hackathon:actions'

actions = Object.create null

actions.on = require './on'
actions.off = require './off'
actions.toggle = require './toggle'


exports.execute = (type, data) ->
  action = actions[type]

  return console.error('Specified action not exists, ignoring... (type: %s)', type) unless action

  log 'calling action with data: ', data

  action data

  log('Called action %s handler', type)
