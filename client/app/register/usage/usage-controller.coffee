'use strict'

angular.module 'energyHackathonApp'
.controller 'UsageCtrl', ($scope, $state, Device, toastr, Recipe, Auth) ->
  $scope.user = Auth.getCurrentUser()
  $scope.devices = Device.get()
  $scope.recipe =
    Usage:
      calc: 'average'

  $scope.createRecipe = () ->
    $scope.recipe.type = 'usage'
    $scope.recipe.user = $scope.user._id
    Recipe.save $scope.recipe
    .$promise.then () ->
      toastr.success '성공적으로 설정되었습니다.'
      $state.go 'main.type'
