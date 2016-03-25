'use strict'

angular.module 'energyHackathonApp'
.controller 'RegisterCtrl', ($scope, $state) ->
  $scope.currentRegisterTitle = '트리거를 설정합니다.'
  $scope.goNextState = () ->
    console.log 'state', $state
    if $state.is 'register.type'
      $state.go 'register.datetime'
    else if $state.is 'resiter.datetime'
      $state.go 'register.action'
