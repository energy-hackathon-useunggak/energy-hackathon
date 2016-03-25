
mongoose = require 'mongoose'
Recipe = mongoose.model 'Recipe'

exports.index = (req, res) ->
    Recipe.find
      user: req.user._id
    .populate 'device'
    .exec (err, recipes) ->
      return res.sendStatus(500).send(err) if err
      res.status(200).json(recipes)

exports.create = (req, res, next) ->
  newRecipe = new Recipe req.body
  newRecipe.save (err, recipe) ->
    return res.status(500).json(err) if err
    res.status(200).json(recipe)
