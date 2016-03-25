'use strict'

angular.module 'energyHackathonApp'
.controller 'MainCtrl', ($scope, $http, socket, Device, $window) ->

  $scope.addThing = ->
    Device.get()
#    return if $scope.newThing is ''
#    $http.post '/api/things',
#      name: $scope.newThing
#
#    $scope.newThing = ''

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'thing'

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider