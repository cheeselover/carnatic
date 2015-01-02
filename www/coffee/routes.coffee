angular.module('carnatic')

.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state('login', {
    url: '/login'
    templateUrl: 'templates/loginView.html'
    controller: 'LoginCtrl'

  }).state('register', {
    url: '/register'
    templateUrl: 'templates/registerView.html'
    controller: 'RegisterCtrl'

  }).state('app', {
    url: '/app'
    abstract: true
    templateUrl: 'templates/menu.html'

  }).state('app.compose', {
    url: '/compose'
    views:
      'menuContent':
        templateUrl: 'templates/composeView.html'
        controller: 'ComposeCtrl'
        resolve:
          korvais: (Auth) ->
            Auth.user.korvais()

  }).state('app.korvais', {
    url: '/korvais'
    views:
      'menuContent':
        templateUrl: 'templates/korvaisView.html'
        controller: 'KorvaisCtrl'
        resolve:
          korvais: (Auth) ->
            Auth.user.korvais()

  }).state('app.korvai-detail', {
    url: '/korvais/:korvaiId'
    views:
      'menuContent':
        templateUrl: 'templates/korvaiDetailView.html'
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
        templateUrl: 'templates/accountView.html'
        controller: 'AccountCtrl'
        resolve:
          userProfile: (Auth) ->
            Auth.user.userProfile()

          friends: (Auth) ->
            Auth.user.friends()

  }).state('app.search', {
    url: '/search'
    views:
      'menuContent':
        templateUrl: 'templates/searchView.html'
        controller: 'SearchCtrl'
        resolve:
          userProfiles: (UserProfileList) ->
            new UserProfileList("public").$loaded()
  })

  $urlRouterProvider.otherwise('/app/compose')