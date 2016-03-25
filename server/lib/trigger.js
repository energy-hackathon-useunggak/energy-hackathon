'use strict';

/**
 * Module dependencies.
 */
var
  childProcess  = require('child_process'),
  debug         = require('debug');




/**
 * Module-specific configurations.
 */

var
  log           = debug('energy-hackathon:Trigger');


function ValidationError(message) {
  Error.call(this);
  Error.captureStackTrace(this, ValidationError);
  this.name = 'ValidationError';
  this.message = message;
  this.status = 400;
}

var noop = function () {};

var Trigger = function TriggerConstructor () {
  this.worker = null;
  this.name = 'Trigger';
  this._queue = [];
};


Trigger.prototype.create = function create (data, done) {
  log('Create trigger, validate data...', data);

  this.validate(data, function(e) {
    if (e) { return done(e); }

    log('Got valid data.');

    var message = {
      event: 'subscribe',
      data: data
    };


    this.worker ? this.worker.send(message) : this._queue.push(message);
  }.bind(this));
};

Trigger.prototype.validate = function validate (data, done) {
  done = done || noop;

  process.nextTick(function() {
    done(null);
  });
};


Trigger.prototype.run = function run () {
  if (this.worker) {
    return;
  }


  var worker = null;

  var
    onWorkerOnline = function(data) {
      log('Got message from worker: ', data);
      var evt = data && data.event;

      if (evt === 'online') {
        worker.removeListener('message', onWorkerOnline);
        worker.on('message', this.onWorkerMessage);
        this.worker = worker;

        // @todo Reload previous subscribers
        if (this._queue.length) {
          this._queue.forEach(function(msg) { this.worker.send(msg); }.bind(this));
        }
      }
    }.bind(this);


  worker = childProcess.fork(`./triggers/${this.name}/dispatcher`);
  worker.on('message', onWorkerOnline);
  worker.on('exit', this.onWorkerDie.bind(this));
};

Trigger.prototype.onWorkerDie = function onWorkerDie (code, signal) {
  this.worker = null;
  log(`Worker died with exit code ${code} (signal: ${signal}). Restarting dispatcher...`);

  this.run();
};


Trigger.prototype.onWorkerMessage = function onWorkerMessage (data) {
  var evt = data && data.event;

  if (evt === 'publish') {
    log('Got publish event: ', data);
    // @todo Run specified Action.
  }
};



Trigger.ValidationError = ValidationError;
module.exports = exports = Trigger;
