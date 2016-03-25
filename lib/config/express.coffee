'use strict'

path            = require 'path'
express         = require 'express'
favicon         = require 'static-favicon'
morgan          = require 'morgan'
compression     = require 'compression'
bodyParser      = require 'body-parser'
multer          = require 'multer'
methodOverride  = require 'method-override'
cookieParser    = require 'cookie-parser'
session         = require 'express-session'
passport        = require 'passport'
redisStore      = require('connect-redis')(session)
multer          = require 'multer'
redis           = require 'redis'



client = redis.createClient()

# Express configuration
module.exports = (app) ->
  env = app.get('env')

  if 'development' is env
    crossDomain = (req, res, next) ->
      res.header('Access-Control-Allow-Credentials', true);
      res.header('Access-Control-Allow-Origin', req.headers.origin);
      res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
      res.header('Access-Control-Allow-Headers', 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Accept');
      if 'OPTIONS' is req.method
        res.send(200)
      else
        next()

    app.use(crossDomain)
    app.use(express.static(path.join('../dist', '../public')))
    app.use(express.static(path.join('../dist', 'client'), index: false))
    app.use(express.static(path.join('../dist', 'public')))

  if 'production' is env
    app.set('trust proxy', true)
    app.use(compression())
    app.use(favicon(path.join('../dist', 'public', 'favicon.ico')))
    app.use(express.static(path.join('../dist', 'public'), index: false))

  noCache = (req, res, next) ->
    if req.url.indexOf('/api/') is 0
      res.header('Cache-Control', 'no-cache, no-store, must-revalidate')
      res.header('Pragma', 'no-cache')
      res.header('Expires', 0)
    next()

  app.use(noCache)

  apiPath = path.join('../dist', 'lib/views').toString()

  app.engine('jade', require('jade').__express)
  app.engine('html', require('ejs').renderFile)

  app.set('view engine', 'jade')

  # app.use(morgan('dev'))
  app.use(bodyParser())
  app.use(multer())
  app.use(methodOverride())
  app.use(cookieParser())
  app.use(multer())

  app.use session
    secret: 'angular-fullstack secret'
    resave: false
    saveUninitialized: true
    store: new redisStore
      host: 'localhost'
      port: 6379
      db: 2
    cookie:
      secure: env is 'production'


  # Use passport session
  app.use(passport.initialize())
  app.use(passport.session())
