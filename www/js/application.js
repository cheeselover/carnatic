angular.module("carnatic", ["ionic", "firebase", "carnatic.controllers", "carnatic.services"]).run(function($ionicPlatform) {
  return $ionicPlatform.ready(function() {
    var _ref, _ref1, _ref2;
    if ((_ref = window.cordova) != null) {
      if ((_ref1 = _ref.plugins.Keyboard) != null) {
        _ref1.hideKeyboardAccessoryBar();
      }
    }
    return (_ref2 = window.StatusBar) != null ? _ref2.styleDefault() : void 0;
  });
}).config(function($stateProvider, $urlRouterProvider) {
  $stateProvider.state("tab", {
    url: "/tab",
    abstract: true,
    templateUrl: "templates/tabs.html"
  }).state("tab.compose", {
    url: "/compose",
    views: {
      "tab-compose": {
        templateUrl: "templates/tab-compose.html",
        controller: "ComposeCtrl"
      }
    }
  }).state("tab.korvais", {
    url: "/korvais",
    views: {
      "tab-korvais": {
        templateUrl: "templates/tab-korvais.html",
        controller: "KorvaisCtrl"
      }
    }
  }).state("tab.korvai-detail", {
    url: "/korvais/:korvaiId",
    views: {
      "tab-korvais": {
        templateUrl: "templates/korvai-detail.html",
        controller: "KorvaiDetailCtrl"
      }
    }
  }).state("tab.account", {
    url: "/account",
    views: {
      "tab-account": {
        templateUrl: "templates/tab-account.html",
        controller: "AccountCtrl"
      }
    }
  });
  return $urlRouterProvider.otherwise("/tab/compose");
});

angular.module("carnatic.controllers", []).controller("ComposeCtrl", function($scope) {
  var myFirebase;
  myFirebase = new Firebase('https://blazing-fire-7995.firebaseio.com/');
  return myFirebase.push({
    just: "testing something out"
  });
}).controller("KorvaisCtrl", function($scope, Korvais) {
  return $scope.korvais = Korvais.all();
}).controller("KorvaiDetailCtrl", function($scope, $stateParams, Korvais) {
  return $scope.korvai = Korvais.get($stateParams.korvaiId);
}).controller("AccountCtrl", function($scope) {
  var test_str;
  test_str = "thaka thakida thakathimi";
  return $scope.korvai = test_str.length - test_str.replace(/[aeiou]/g, '').length;
});

angular.module("carnatic.services", []).factory("Korvais", function() {
  var korvais;
  korvais = [
    {
      id: 0,
      name: "This is awesome"
    }, {
      id: 1,
      name: "G.I. Joe"
    }, {
      id: 2,
      name: "Miss Frizzle"
    }, {
      id: 3,
      name: "Ash Ketchum"
    }
  ];
  return {
    all: function() {
      return korvais;
    },
    get: function(korvaiId) {
      return korvais[korvaiId];
    }
  };
});
