'use strict'

angular.module 'energyHackathonApp'
.controller 'UsageCtrl', ($scope, Device) ->
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
    usage:
      calc: 'average'
