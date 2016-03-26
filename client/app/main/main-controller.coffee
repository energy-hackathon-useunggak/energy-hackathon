'use strict'

angular.module 'energyHackathonApp'
.controller 'MainCtrl', ($scope, $http, Device, Recipe, $window, Auth) ->
  $scope.user = Auth.getCurrentUser()

  $scope.daysofweek = [ '일', '월', '화', '수', '목', '금', '토' ]

  parseCronDate = (cronString) ->
    dateTokens = cronString.split(' ')
    date =
      dayofweek: dateTokens[5]
      day: dateTokens[3]
      hour: dateTokens[2]
      minute: dateTokens[1]
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
      date = parseCronDate recipe.Date
      if date.period is '주'
        recipe.desc = '매 주 ' + $scope.daysofweek[date.dayofweek] + '요일 ' + date.hour + '시 마다 '
      else if date.period is '월'
        recipe.desc = '매 월 ' + date.day + '일 ' + date.hour + '시 마다 '
      else if date.period is '일'
        recipe.desc = '매 일 ' + date.hour + '시 ' + date.minute + '분 마다 '
      else
        recipe.desc = '매 시 ' + date.minute + '분 마다 '
    else
      recipe.desc = "#{recipe.Usage.minute}분 동안 #{recipe.Usage.device.name} 전력 평균이 "
      if recipe.Usage.condition is 'under'
        recipe.desc += recipe.Usage.value + 'W 미만이면 '
      else
        recipe.desc += recipe.Usage.value + 'W 이상이면 '

    recipe.desc += recipe.device.name + '의 전원을 '
    if recipe.action is 'on'
      recipe.desc += '켭니다'
    else if recipe.action is 'off'
      recipe.desc += '끕니다'
    else
      recipe.desc += '토글합니다'

    return recipe

  # $scope.recipes = Recipe.get().map (recipe) ->
  #   console.log recipe
  Recipe.get()
  .$promise.then (recipes) ->
    $scope.recipes = recipes.map getDescription

  # $scope.recipes = $scope.recipes.map getDescription

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
