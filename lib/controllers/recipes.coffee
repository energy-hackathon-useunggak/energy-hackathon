
mongoose = require 'mongoose'
triggers = require '../triggers/'
Recipe = mongoose.model 'Recipe'

exports.index = (req, res) ->
    Recipe.find
      user: req.user._id
    .populate 'device'
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

    triggers.create newRecipe.type, data, (e) ->
      console.error(e.stack) if e
