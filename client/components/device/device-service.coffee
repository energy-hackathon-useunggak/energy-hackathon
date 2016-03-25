'use strict'

angular.module 'energyHackathonApp'
.factory 'Device', ($resource) ->
  $resource '/api/devices/',
    {},
    get:
      method: 'GET'
      isArray: true

