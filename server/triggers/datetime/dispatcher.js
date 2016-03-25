'use strict';

/**
 * Module dependencies.
 */
const
  cron = require('cron');

/**
 * Module specific configurations.
 */

process.on('message', (data) => {
  if (data.event === 'subscribe') {
    console.log('cron string: ', data.data.cron);
    var job = new cron.CronJob(data.data.cron, function () {
      console.log('tick');
      process.send({
        event: 'publish',
        data: data.data
      });
    }, null, true);
  }
});

process.send({
  event: 'online'
});
