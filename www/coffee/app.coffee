angular.module('carnatic', [
  'ionic'
  'firebase'
  'carnatic.controllers'
  'carnatic.factories'
])

.run ($ionicPlatform) ->
  $ionicPlatform.ready ->
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)

    if window.StatusBar
      StatusBar.styleDefault()

.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise('/tab/compose')

  $stateProvider.state('login', {
    url: '/login'
    templateUrl: 'templates/login.html'
    controller: 'LoginCtrl'
  }).state('register', {
    url: '/register'
    templateUrl: 'templates/register.html'
    controller: 'RegisterCtrl'
  }).state('tab', {
    url: '/tab'
    abstract: true
    templateUrl: 'templates/tabs/tabs.html'
  }).state('tab.compose', {
    url: '/compose'
    views:
      'tab-compose':
        templateUrl: 'templates/tabs/compose.html'
        controller: 'ComposeCtrl'
  }).state('tab.korvais', {
    url: '/korvais'
    views:
      'tab-korvais':
        templateUrl: 'templates/tabs/korvais.html'
        controller: 'KorvaisCtrl'
  }).state('tab.account', {
    url: '/account'
    views:
      'tab-account':
        templateUrl: 'templates/tabs/account.html'
        controller: 'AccountCtrl'
  })

angular.module 'carnatic.controllers', []
angular.module 'carnatic.factories', []
