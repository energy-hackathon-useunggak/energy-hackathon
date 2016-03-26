'use strict'

angular.module 'energyHackathonApp'
.controller 'UsageCtrl', ($scope, $state, Device, toastr, Recipe, Auth) ->
  $scope.user = Auth.getCurrentUser()
  $scope.devices = Device.get()
#    name: '냉장고',
#    uuid: '1'
#  ,
#    name: '충전기',
#    uuid: '2'
#  ,
#    name: '세탁기',
#    uuid: '3'
#  ,
#    name: '스탠드',
#    uuid: '4'
#  ]

  $scope.recipe =
    Usage:
      calc: 'average'

  $scope.createRecipe = () ->
    $scope.recipe.type = 'usage'
    $scope.recipe.user = $scope.user._id
    Recipe.save $scope.recipe
    .$promise.then () ->
      toastr.success '성공적으로 설정되었습니다.'
      $state.go 'main'
