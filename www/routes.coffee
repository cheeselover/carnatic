angular.module('carnatic')

.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state('login', {
    url: '/login'
    templateUrl: 'components/Login/loginView.html'
    controller: 'LoginCtrl'

  }).state('register', {
    url: '/register'
    templateUrl: 'components/Login/registerView.html'
    controller: 'RegisterCtrl'

  }).state('app', {
    url: '/app'
    abstract: true
    templateUrl: 'shared/Sidemenu/menu.html'

  }).state('app.compose', {
    url: '/compose'
    views:
      'menuContent':
        templateUrl: 'components/Compose/composeView.html'
        controller: 'ComposeCtrl'
        resolve:
          korvais: (Auth) ->
            Auth.user.korvais()

  }).state('app.korvais', {
    url: '/korvais'
    views:
      'menuContent':
        templateUrl: 'components/Korvais/korvaisView.html'
        controller: 'KorvaisCtrl'
        resolve:
          korvais: (Auth) ->
            Auth.user.korvais()

  }).state('app.korvai-detail', {
    url: '/korvais/:korvaiId'
    views:
      'menuContent':
        templateUrl: 'components/Korvais/korvaiDetailView.html'
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
        templateUrl: 'components/Account/accountView.html'
        controller: 'AccountCtrl'
        resolve:
          userProfile: (Auth) ->
            Auth.user.userProfile()

          friends: (Auth) ->
            Auth.user.friends()
  })

  $urlRouterProvider.otherwise('/app/compose')
]