'use strict'

angular.module 'energyHackathonApp'
.controller 'MainCtrl', ($scope, $http, Device, $window, Auth) ->
  user = Auth.getCurrentUser()
  console.log user

  $scope.recipes = [
    user: '56f4ccc45b250b8c6d11cba6'
    action: 'toggle'
    date: '00 30 12 * * *'
    device:
      _id: '2'
      name: '다리미'
    type: 'datetime'
    usage: { }
  ,
    user: '56f4ccc45b250b8c6d11cba6'
    action: 'off'
    device:
      _id: '3'
      name: '냉장고'
    type: 'usage'
    usage:
      calc: 'average'
      condition: 'under'
      device:
        _id: '3'
        name: '냉장고'
      minute: 30
      value: 12
  ]

  $scope.daysofweek = [ '일', '월', '화', '수', '목', '금', '토' ]

  parseCronDate = (cronString) ->
    dateTokens = cronString.split(' ')
    date =
      dayofweek: [5]
      day: [3]
      hour: dateTokens[2]
      miniute: dateTokens[1]
    if date.dayofweek isnt '*'
      date.period = '주'
    else if date.day isnt '*'
      date.period = '월'
    else if date.hour isnt '*'
      date.period = '일'
    else
      date.period = '시'
    return date

  getDescription = (recipe) ->
    if recipe.type is 'datetime'
      date = parseCronDate recipe.date
      if date.period is '주'
        recipe.desc = '매 주 ' + $scope.daysofweek[date.dayofweek] + '요일 '
        + date.hour + '시 마다'
      else if date.period is '월'
        recipe.desc = '매 월 ' + $scope.day + '일 '
        + date.hour + '시 마다'
      else if date.period is '일'
        recipe.desc = '매 일 ' + $scope.hour + '시 '
        + date.minute + '분 마다'
      else
        recipe.desc = '매 시 ' + $scope.minute + '분 = 마다'
    else
      recipe.desc = "#{recipe.usage.minute}분 동안 #{recipe.usage.device.name} 전력 평균이 "
      if recipe.usage.condition is 'under'
        recipe.desc += recipe.usage.value + 'W 미만이면 '
      else
        recipe.desc += recipe.usage.value + 'W 이상이면 '

    recipe.desc += recipe.device.name + '의 전원을 '
    if recipe.action is 'on'
      recipe.desc += '켭니다'
    else if recipe.action is 'off'
      recipe.desc += '끕니다'
    else
      recipe.desc += '토글합니다'
    return recipe

  $scope.recipes = $scope.recipes.map getDescription

  $scope.addThing = ->
    Device.get()
    .$promise.then (devices) ->
      console.log devices
#    return if $scope.newThing is ''
#    $http.post '/api/things',
#      name: $scope.newThing
#
#    $scope.newThing = ''

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'thing'

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
