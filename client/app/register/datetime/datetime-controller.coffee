'use strict'

angular.module 'energyHackathonApp'
.controller 'DatetimeCtrl', ($scope, $state, toastr, Device, Recipe, Auth) ->
  $scope.devices = Device.get()
  $scope.user = Auth.getCurrentUser()

  $scope.periods = [ '시', '일', '주', '달' ]
  $scope.daysofweek = [ '일', '월', '화', '수', '목', '금', '토' ]

  $scope.recipe =
    usage: {}

  getCronDate = () ->
    if $scope.period is '월'
      return '00 00 ' + $scope.hour + ' ' + $scope.day + ' * *'
    else if $scope.period is '주'
      return '00 00 ' + $scope.hour + ' * * ' + $scope.dayofweek
    else if $scope.period is '일'
      return '00 ' + $scope.minute + ' ' + $scope.hour + ' * * *'
    else # if $scope.period is '시'
      return '00 ' + $scope.minute + ' * * * *'

  $scope.createRecipe = () ->
    $scope.recipe.user = $scope.user._id
    $scope.recipe.Date = getCronDate()
    $scope.recipe.type = 'datetime'
    Recipe.save $scope.recipe
    .$promise.then (res) ->
      toastr.success '성공적으로 설정했습니다.'
      $state.go 'main.type'
