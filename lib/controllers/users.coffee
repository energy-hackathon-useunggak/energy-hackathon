'use strict'

mongoose = require 'mongoose'
User    = mongoose.model 'User'

exports.me = (req, res) ->
  userId = req.user._id
  console.log userId
  User.findOne
    _id: userId
  , '-salt -hashedPassword', (err, user) -> # don't ever give out the password or salt
    return next(err) if err
    return res.status(401).send('Unauthorized') unless user

    res.json user
