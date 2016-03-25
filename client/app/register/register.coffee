'use strict'

angular.module 'energyHackathonApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'register',
    url: '/register'
    templateUrl: 'app/register/register.html'
    controller: 'RegisterCtrl'
    abstract: true
  .state 'register.type',
    url: '/type'
    templateUrl: 'app/register/steps/type.html'
  .state 'register.datetime',
    url: '/datetime'
    templateUrl: 'app/register/steps/datetime.html'
  .state 'register.usage',
    url: '/usage'
    templateUrl: 'app/register/steps/usage.html'
  .state 'register.action',
    url: '/action'
    templateUrl: 'app/register/steps/action.html'
