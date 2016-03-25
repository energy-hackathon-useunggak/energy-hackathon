'use strict';

/**
 * Module dependencies.
 */
const
  childProcess  = require('child_process'),
  debug         = require('debug');




/**
 * Module-specific configurations.
 */

const
  log           = debug('energy-hackathon:Trigger');


function ValidationError(message) {
  Error.call(this);
  Error.captureStackTrace(this, ValidationError);
  this.name = 'ValidationError';
  this.message = message;
  this.status = 400;
}

const noop = () => {};

const Trigger = function TriggerConstructor () {
  this.worker = null;
  this.name = 'Trigger';
  this._queue = [];
};


Trigger.prototype.create = function create (data, done) {
  log('Create trigger, validate data...', data);

  this.validate(data, (e) => {
    if (e) { return done(e); }

    log('Got valid data.');

    var message = {
      event: 'subscribe',
      data: data
    };


    this.worker ? this.worker.send(message) : this._queue.push(message);
  });
};

Trigger.prototype.validate = function validate (data, done) {
  done = done || noop;

  process.nextTick(() => {
    done(null);
  });
};


Trigger.prototype.run = function run () {
  if (this.worker) {
    return;
  }


  var worker = null;

  const
    onWorkerOnline = (data) => {
      log('Got message from worker: ', data);
      const evt = data && data.event;

      if (evt === 'online') {
        worker.removeListener('message', onWorkerOnline);
        worker.on('message', this.onWorkerMessage);
        this.worker = worker;

        // @todo Reload previous subscribers
        if (this._queue.length) {
          this._queue.forEach((msg) => this.worker.send(msg));
        }
      }
    };


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
  const evt = data && data.event;

  if (evt === 'publish') {
    log('Got publish event: ', data);
    // @todo Run specified Action.
  }
};



Trigger.ValidationError = ValidationError;
module.exports = exports = Trigger;
