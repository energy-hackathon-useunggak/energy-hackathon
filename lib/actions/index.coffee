'use strict'

actions = Object.create null

actions.on = require './on'
actions.off = require './off'
actions.toggle = require './toggle'


exports.execute = (type, data) ->
  action = actions[type]

  return done(new Error('Failed to find specified type')) unless action

  action data
