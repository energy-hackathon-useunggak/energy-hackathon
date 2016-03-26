'use strict'

actions = Object.create null

actions.on = require './on'
actions.off = require './off'
actions.toggle = require './toggle'


exports.execute = (type, data) ->
  action = actions[type]

  return console.error('Specified action not exists, ignoring... (type: %s)', type) unless action

  action data
