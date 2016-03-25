'use strict'
path = require 'path'

exports.index = (req, res) ->
  res.sendFile(path.join(__dirname, if process.env.NODE_ENV is 'development' then '../../client' else '../../public')+ '/index.html')
