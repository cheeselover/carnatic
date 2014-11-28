angular.module('carnatic', [
  'ionic'
  'firebase'
  'carnatic.controllers'
])

.run ($ionicPlatform) ->
  $ionicPlatform.ready ->
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)

    if window.StatusBar
      StatusBar.styleDefault()

.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise('/')

  $stateProvider.state('login', {
    url: '/'
    templateUrl: 'templates/login.html'
    controller: 'LoginCtrl'
  }).state('register', {
    url: '/register'
    templateUrl: 'templates/register.html'
    controller: 'RegisterCtrl'
  })
