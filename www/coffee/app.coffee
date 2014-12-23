angular.module('carnatic', [
  'ionic'
  'firebase'
  'carnatic.controllers'
  'carnatic.factories'
  'carnatic.models'
  'carnatic.directives'
])

.run ['$ionicPlatform', '$rootScope', 'Auth', ($ionicPlatform, $rootScope, Auth) ->
  $ionicPlatform.ready ->
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)

    if window.StatusBar
      StatusBar.styleDefault()

  $rootScope.$on '$stateChangeStart', (event, toState) ->
    if toState.name.substring(0, 3) is 'app'
      Auth.authRef.$waitForAuth().then (user) ->
        if not user?
          location.href = "/#/login"
]

.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state('login', {
    url: '/login'
    templateUrl: 'templates/login.html'
    controller: 'LoginCtrl'

  }).state('register', {
    url: '/register'
    templateUrl: 'templates/register.html'
    controller: 'RegisterCtrl'

  }).state('app', {
    url: '/app'
    abstract: true
    templateUrl: 'templates/sidemenu/menu.html'

  }).state('app.compose', {
    url: '/compose'
    views:
      'menuContent':
        templateUrl: 'templates/sidemenu/compose.html'
        controller: 'ComposeCtrl'
        resolve:
          korvais: (Auth) ->
            Auth.user.korvais()

  }).state('app.korvais', {
    url: '/korvais'
    views:
      'menuContent':
        templateUrl: 'templates/sidemenu/korvais.html'
        controller: 'KorvaisCtrl'
        resolve:
          korvais: (Auth) ->
            Auth.user.korvais()

  }).state('app.korvai-detail', {
    url: '/korvais/:korvaiId'
    views:
      'menuContent':
        templateUrl: 'templates/sidemenu/korvai-detail.html'
        controller: 'KorvaiDetailCtrl'
        resolve:
          korvai: ($stateParams, $q, Auth) ->
            deferred = $q.defer()
            deferred.resolve(Auth.user.korvais().then (korvais) ->
              korvais.$getRecord($stateParams.korvaiId))
            return deferred.promise

  }).state('app.account', {
    url: '/account'
    views:
      'menuContent':
        templateUrl: 'templates/sidemenu/account.html'
        controller: 'AccountCtrl'
        resolve:
          userProfile: (Auth) ->
            Auth.user.userProfile()
  })

  $urlRouterProvider.otherwise('/app/compose')
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
