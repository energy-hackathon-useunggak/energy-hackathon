_         = require 'underscore'
mongoose  = require 'mongoose'
triggers  = require '../triggers/'
Device    = mongoose.model 'Device'
Recipe    = mongoose.model 'Recipe'

exports.index = (req, res) ->
    Recipe.find
      user: req.user._id
    .populate 'device'
    .populate 'Usage.device'
    .exec (err, recipes) ->
      return res.sendStatus(500).send(err) if err
      res.status(200).json(recipes)

exports.create = (req, res) ->
  newRecipe = new Recipe req.body
  newRecipe.save (err, recipe) ->
    return res.status(500).json(err) if err
    res.status(200).json(recipe)

    data = switch newRecipe.type
      when 'datetime' then cron: newRecipe.Date
      when 'usage' then {}
      else {}

    Device.findById newRecipe.device
    .exec (e, device) ->
      return console.error(e.stack) if e
      return console.error('Device not found (_id: %s)', newRecipe.device) unless device


      data.user = newRecipe.user
      data.action = newRecipe.action

      console.log newRecipe, newRecipe.Usage
      console.log data

      data.uuid = device.uuid
      data.usage = newRecipe.toObject().Usage if newRecipe.type is 'usage'

      triggers.create newRecipe.type, data, (e) ->
        console.error(e.stack) if e
