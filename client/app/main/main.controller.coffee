'use strict'

angular.module 'energyHackathonApp'
.controller 'MainCtrl', ($scope, $window, Auth, $cookieStore) ->
  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider

  # console.log 'curr: ', $cookieStore.get 'token'
