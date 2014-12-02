angular.module('carnatic', ['ionic', 'firebase', 'carnatic.controllers', 'carnatic.factories']).run([
  '$ionicPlatform', '$rootScope', '$state', 'Auth', function($ionicPlatform, $rootScope, $state, Auth) {
    $ionicPlatform.ready(function() {
      if (window.cordova && window.cordova.plugins.Keyboard) {
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      }
      if (window.StatusBar) {
        return StatusBar.styleDefault();
      }
    });
    return $rootScope.$on('$stateChangeStart', function(event, toState) {
      if (toState.name.substring(0, 3) === 'tab') {
        return Auth.$waitForAuth().then(function(user) {
          if (user == null) {
            return $state.go('login');
          }
        });
      }
    });
  }
]).config([
  '$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/tab/compose');
    return $stateProvider.state('login', {
      url: '/login',
      templateUrl: 'templates/login.html',
      controller: 'LoginCtrl'
    }).state('register', {
      url: '/register',
      templateUrl: 'templates/register.html',
      controller: 'RegisterCtrl'
    }).state('tab', {
      url: '/tab',
      abstract: true,
      templateUrl: 'templates/tabs/tabs.html'
    }).state('tab.compose', {
      url: '/compose',
      views: {
        'tab-compose': {
          templateUrl: 'templates/tabs/compose.html',
          controller: 'ComposeCtrl'
        }
      }
    }).state('tab.korvais', {
      url: '/korvais',
      views: {
        'tab-korvais': {
          templateUrl: 'templates/tabs/korvais.html',
          controller: 'KorvaisCtrl'
        }
      }
    }).state('tab.account', {
      url: '/account',
      views: {
        'tab-account': {
          templateUrl: 'templates/tabs/account.html',
          controller: 'AccountCtrl'
        }
      }
    });
  }
]);

angular.module('carnatic.controllers', []);

angular.module('carnatic.factories', []);

angular.module('carnatic.controllers').controller("AccountCtrl", function($scope) {
  return "placeholder";
});

angular.module('carnatic.controllers').controller("ComposeCtrl", function($scope) {
  return "placeholder";
});

angular.module('carnatic.controllers').controller("KorvaisCtrl", function($scope) {
  return "placeholder";
});

angular.module('carnatic.controllers').controller("LoginCtrl", [
  '$scope', 'Auth', function($scope, Auth) {
    $scope.auth = Auth;
    $scope.user = $scope.auth.$getAuth();
    $scope.login = function(data) {
      return Auth.$authWithPassword({
        email: data.email,
        password: data.password
      }, {
        remember: "sessionOnly"
      }).then(function(authData) {
        return location.reload();
      })["catch"](function(error) {
        return alert("Authentication failed: " + error);
      });
    };
    return $scope.logout = function() {
      $scope.auth.$unauth();
      return location.reload();
    };
  }
]);

angular.module('carnatic.controllers').controller("RegisterCtrl", function($scope) {
  var ref;
  ref = new Firebase('https://carnatic.firebaseio.com');
  return $scope.register = function(data) {
    if (data.password === data.password_confirm) {
      return ref.createUser({
        email: data.email,
        password: data.password
      }, function(error) {
        if (error) {
          switch (error.code) {
            case "EMAIL_TAKEN":
              alert("Email already in use.");
              break;
            case "INVALID EMAIL":
              alert("Email not valid");
              break;
            default:
              return alert("Error creating user: " + error);
          }
        } else {
          alert("User creation success!");
          return ref.child("users").child(data.username).set({
            username: data.username,
            name: data.name,
            email: data.email
          });
        }
      });
    } else {
      return alert("Password did not match confirmation.");
    }
  };
});

angular.module('carnatic.factories').factory("Auth", [
  "$firebaseAuth", function($firebaseAuth) {
    return $firebaseAuth(new Firebase('https://carnatic.firebaseio.com'));
  }
]);
