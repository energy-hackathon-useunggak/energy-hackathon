'use strict'

angular.module 'energyHackathonApp'
.controller 'RegisterCtrl', ($scope, $state, toastr) ->
  $scope.currentRegisterTitle = '새로운 레시피를 만듭니다.'
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
    device: $scope.devices[0]

  # $scope.period = '일'
  # $scope.hour = 12
  # $scope.minute = 30
  # $scope.day = 28
  # $scope.dayofweek = 1

  getCronDate = () ->
    if $scope.period is '월'
      return '00 00 ' + $scope.hour + ' ' + $scope.day + ' *'
    else if $scope.period is '주'
      return '00 00 ' + $scope.hour + ' * * ' + $scope.dayofweek
    else if $scope.period is '일'
      return '00 ' + $scope.minute + ' ' + $scope.hour + ' * * *'
    else # if $scope.period is '시'
      return '00 ' + $scope.minute + ' * * * *'

  $scope.$state = $state
  $scope.goNextState = () ->
    if $state.is 'register.type'
      if $scope.recipe.type is 'datetime'
        $scope.currentRegisterTitle = '동작할 시간을 입력해주세요.'
        $state.go "register.#{$scope.recipe.type}"
      else if $scope.recipe.type is 'usage'
        $scope.currentRegisterTitle = '동작할 조건을 입력해주세요.'
        $state.go "register.#{$scope.recipe.type}"
      else
        toastr.warning '레시피 종류를 선택해주세요.'
    else if $state.is 'register.datetime'
      $scope.recipe.date = getCronDate()
      $scope.currentRegisterTitle = '자동으로 실행될 동작을 입력해주세요.'
      $state.go 'register.action'
    else if $state.is 'register.usage'
      $scope.currentRegisterTitle = '자동으로 실행될 동작을 입력해주세요.'
      $state.go 'register.action'
