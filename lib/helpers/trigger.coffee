'use strict'

# Module dependencies.
path          = require 'path'
childProcess  = require 'child_process'
debug         = require 'debug'
actions       = require '../actions'

# Module-specific configurations.

log           = debug 'energy-hackathon:Trigger'


ValidationError = (message) ->
  Error.call this
  Error.captureStackTrace this, ValidationError
  @name = 'ValidationError'
  @message = message
  @status = 400

noop = () ->


class Trigger
  @ValidationError: ValidationError
  constructor: () ->
    @worker = null;
    @name = 'Trigger'
    @_queue = []
  create: (data, done) ->
    log 'Create trigger, validate data...', data
    @validate data, (e) =>
      return done(e) if e
      log 'Got valid data.'

      message =
        event: 'subscribe',
        data: data

      if @worker
        @worker.send message
      else
        @_queue.push message

  validate: (data, done) ->
    done = done || noop;

    process.nextTick () ->
      done null
  run: () ->
    return if @worker

    worker = null;

    onWorkerOnline = (data) =>
      log 'Got message from worker: ', data

      evt = data && data.event;

      if evt is 'online'
        worker.removeListener('message', onWorkerOnline);
        worker.on('message', @onWorkerMessage);
        @worker = worker

        # @todo Reload previous subscribers
        if @_queue.length
          @_queue.forEach (msg) =>
            @worker.send(msg)

    worker = childProcess.fork path.join(__dirname, "../triggers/#{@name}/dispatcher")
    worker.on 'message', onWorkerOnline
    worker.on 'exit', @onWorkerDie.bind(this)

  onWorkerDie: (code, signal) ->
    @worker = null
    log "Worker died with exit code #{code} (signal: #{signal}). Restarting dispatcher..."

    @run()

  onWorkerMessage: (data) ->
    evt = data && data.event

    if evt is 'publish'
      log 'Got publish event: ', data
      actions.execute(data.data.action, data.data)


module.exports = exports = Trigger
