angular.module("carnatic", [
    "ionic"
    "firebase"
    "carnatic.controllers"
    "carnatic.services"
  ])

  .run(($ionicPlatform) ->
    $ionicPlatform.ready ->
      window.cordova?.plugins.Keyboard?.hideKeyboardAccessoryBar()
      window.StatusBar?.styleDefault()
  )

  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider.state("tab",
      url: "/tab"
      abstract: true
      templateUrl: "templates/tabs.html"
    ).state("tab.compose",
      url: "/compose"
      views:
        "tab-compose":
          templateUrl: "templates/tab-compose.html"
          controller: "ComposeCtrl"
    ).state("tab.korvais",
      url: "/korvais"
      views:
        "tab-korvais":
          templateUrl: "templates/tab-korvais.html"
          controller: "KorvaisCtrl"
    ).state("tab.korvai-detail",
      url: "/korvais/:korvaiId"
      views:
        "tab-korvais":
          templateUrl: "templates/korvai-detail.html"
          controller: "KorvaiDetailCtrl"
    ).state "tab.account",
      url: "/account"
      views:
        "tab-account":
          templateUrl: "templates/tab-account.html"
          controller: "AccountCtrl"

    $urlRouterProvider.otherwise "/tab/compose"
