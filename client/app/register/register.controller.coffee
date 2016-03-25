'use strict'

angular.module 'energyHackathonApp'
.controller 'RegisterCtrl', ($scope, $state, toastr) ->
  $scope.currentRegisterTitle = '트리거를 설정합니다.'
  $scope.devices = [
    name: '냉장고',
    uuid: '1'
  ,
    name: '충전기',
    uuid: '2'
  ,
    name: '세탁기',
    uuid: '3'
  ,
    name: '스탠드',
    uuid: '4'
  ]

  $scope.recipe =
    usage: {}
    device: $scope.devices[0]
    
  $scope.period = 'day'
  $scope.hour = 12
  $scope.minute = 30
  $scope.day = 28
  $scope.dayofweek = 1

  getCronDate = () ->
    if $scope.period is 'month'
      return '00 00 ' + $scope.hour + ' ' + $scope.day + ' *'
    else if $scope.period is 'week'
      return '00 00 ' + $scope.hour + ' * * ' + $scope.dayofweek
    else if $scope.period is 'day'
      return '00 ' + $scope.minute + ' ' + $scope.hour + ' * * *'
    else # if $scope.period is 'hour'
      return '00 ' + $scope.minute + ' * * * *'

  $scope.$state = $state
  $scope.goNextState = () ->
    if $state.is 'register.type'
      if $scope.recipe.type
        $state.go "register.#{$scope.recipe.type}"
      else
        toastr.warning '트리거 종류를 선택해주세요.'
    else if $state.is 'register.datetime'
      $scope.recipe.date = getCronDate()
      $state.go 'register.action'
    else if $state.is 'register.usage'
      $state.go 'register.action'
