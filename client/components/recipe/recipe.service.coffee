'use strict'

angular.module 'energyHackathonApp'
.factory 'Recipe', ($resource) ->
  $resource '/api/recipes/',
  {},
    get:
      method: 'GET'

