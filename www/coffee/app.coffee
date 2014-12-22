angular.module('carnatic', [
  'ionic'
  'firebase'
  'carnatic.controllers'
  'carnatic.factories'
  'carnatic.models'
  'carnatic.directives'
])

.run ['$ionicPlatform', '$rootScope', '$state', 'Auth', ($ionicPlatform, $rootScope, $state, Auth) ->
  $ionicPlatform.ready ->
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)

    if window.StatusBar
      StatusBar.styleDefault()

  $rootScope.$on '$stateChangeStart', (event, toState) ->
    if toState.name.substring(0, 3) is 'tab'
      Auth.authRef.$waitForAuth().then (user) ->
        if not user?
          $state.go 'login'
]

.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
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

  }).state('tab.korvai-detail', {
    url: '/korvais/:korvaiId'
    views:
      'tab-korvais':
        templateUrl: 'templates/tabs/korvai-detail.html'
        controller: 'KorvaiDetailCtrl'

  }).state('tab.account', {
    url: '/account'
    views:
      'tab-account':
        templateUrl: 'templates/tabs/account.html'
        controller: 'AccountCtrl'
  })
]

# Global values
.value('REF', new Firebase("https://carnatic.firebaseio.com/"))

# Module definitions
angular.module 'carnatic.controllers', []
angular.module 'carnatic.factories', []
angular.module 'carnatic.models', []
angular.module 'carnatic.directives', []

# Miscellaneous helpers
String.prototype.repeat = (num) ->
  new Array(num + 1).join(@)
