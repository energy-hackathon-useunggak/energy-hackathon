'use strict'

angular.module 'energyHackathonApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'register',
    url: '/register'
    templateUrl: 'app/register/register.html'
    controller: 'RegisterCtrl'
    abstract: true
  .state 'main.type',
    url: ''
    templateUrl: 'app/register/steps/type.html'
  .state 'main.datetime',
    url: 'datetime'
    templateUrl: 'app/register/datetime/datetime.html'
    controller: 'DatetimeCtrl'
  .state 'main.usage',
    url: 'usage'
    templateUrl: 'app/register/usage/usage.html'
    controller: 'UsageCtrl'
  .state 'register.action',
    url: '/action'
    templateUrl: 'app/register/steps/action.html'
