angular.module("starter", ["ionic", "starter.controllers", "starter.services"]).run(function($ionicPlatform) {
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
  }).state("tab.dash", {
    url: "/dash",
    views: {
      "tab-dash": {
        templateUrl: "templates/tab-dash.html",
        controller: "DashCtrl"
      }
    }
  }).state("tab.friends", {
    url: "/friends",
    views: {
      "tab-friends": {
        templateUrl: "templates/tab-friends.html",
        controller: "FriendsCtrl"
      }
    }
  }).state("tab.friend-detail", {
    url: "/friend/:friendId",
    views: {
      "tab-friends": {
        templateUrl: "templates/friend-detail.html",
        controller: "FriendDetailCtrl"
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
  return $urlRouterProvider.otherwise("/tab/dash");
});

angular.module("starter.controllers", []).controller("DashCtrl", function($scope) {}).controller("FriendsCtrl", function($scope, Friends) {
  return $scope.friends = Friends.all();
}).controller("FriendDetailCtrl", function($scope, $stateParams, Friends) {
  return $scope.friend = Friends.get($stateParams.friendId);
}).controller("AccountCtrl", function($scope) {
  var test_str;
  test_str = "thaka thakida thakathimi";
  return $scope.korvai = test_str.length - test_str.replace(/[aeiou]/g, '').length;
});

angular.module("starter.services", []).factory("Friends", function() {
  var friends;
  friends = [
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
      return friends;
    },
    get: function(friendId) {
      return friends[friendId];
    }
  };
});
