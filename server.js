'use strict';

/**
 * Module dependencies.
 */
const
  express         = require('express'),
  path            = require('path'),
  fs              = require('fs'),
  mongoose        = require('mongoose'),
  autoIncrement   = require('mongoose-auto-increment'),
  env             = require('node-env-file');

/**
 * Application configurations.
 */

// Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

const
  modelsPath = path.join(__dirname, 'lib/models');

env('../.env');
if (process.env.NODE_ENV !== "development") {
  process.on('uncaughtException', (err) => {
    console.log(`Caught exception: [${(new Date()).toISOString()}] :\n${err.stack}\n\n`);
  });
}

/**
 * Setup Application.
 */
const
  app     = express();

const db      = mongoose.connect(process.env.MONGO_URL, {
  options: {
    db: {
      safe: true
    }
}}, (e) => {
  if (e) throw e;

  autoIncrement.initialize(db);

  mongoose.set('debug', process.env.NODE_ENV === "development");

  // Bootstrap models

  fs.readdirSync(modelsPath).forEach((file) => {
    if (/(.*)\.(js$|coffee$)/.test(file)) {
      require(modelsPath + '/' + file);
    }
  });

  // Passport Configuration
  const
    passport = require('./lib/config/passport'),
    server  = require('http').createServer(app),
    io    = require('socket.io').listen(server),
    redis = require('socket.io-redis');

  io.adapter(redis({ host: 'localhost', port: 6379 }));

  require('./lib/config/express')(app);
  require('./lib/routes')(app, io);


  server.listen(process.env.APP_PORT, (socket) => {
    console.log('Express server listening on port %d, in %s mode', process.env.APP_PORT, app.get('env'));
  });
});
