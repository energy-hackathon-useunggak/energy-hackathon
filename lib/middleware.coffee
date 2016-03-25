'use strict'

_             = require 'underscore'
path          = require 'path'
crypto        = require 'crypto'

module.exports =

  auth: (req, res, next) ->
    return next() if req.isAuthenticated()

    res.status 401
    .send authError: true

