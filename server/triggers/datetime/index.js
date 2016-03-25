'use strict';

/**
 * Module dependencies.
 */
const
  util    = require('util'),
  cron    = require('cron'),
  Trigger = require('../../lib/trigger');


const noop = () => {};

const DateTimeTrigger = function DateTimeTriggerConstructor () {
  Trigger.apply(this, arguments);

  this.name = 'datetime';
};

util.inherits(DateTimeTrigger, Trigger);

DateTimeTrigger.prototype.validate = function DateTimeTriggerValidate (data, done) {
  done = done || noop;

  if (! (data && data.cron)) {
    return done(new Trigger.ValidationError('`cron` string should be specified.'));
  }

  try {
    new cron.CronJob(data.cron, noop);
  } catch (e) {
    return done(new Trigger.ValidationError('`cron` is not valid cron format.'));
  }

  process.nextTick(() => {
    done(null);
  });
};


module.exports = exports = DateTimeTrigger;
