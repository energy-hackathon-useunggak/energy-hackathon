'use strict'

angular.module 'energyHackathonApp'
.controller 'DatetimeCtrl', ($scope, $state, toastr) ->
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

  $scope.periods = [ '시', '일', '주', '달' ]
  $scope.daysofweek = [ '일', '월', '화', '수', '목', '금', '토' ]

  $scope.recipe =
    usage: {}

  getCronDate = () ->
    if $scope.period is '월'
      return '00 00 ' + $scope.hour + ' ' + $scope.day + ' *'
    else if $scope.period is '주'
      return '00 00 ' + $scope.hour + ' * * ' + $scope.dayofweek
    else if $scope.period is '일'
      return '00 ' + $scope.minute + ' ' + $scope.hour + ' * * *'
    else # if $scope.period is '시'
      return '00 ' + $scope.minute + ' * * * *'
