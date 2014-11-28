angular.module('carnatic', ['ionic', 'firebase', 'carnatic.controllers']).run(function($ionicPlatform) {
  return $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      return StatusBar.styleDefault();
    }
  });
}).config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise('/');
  return $stateProvider.state('login', {
    url: '/',
    templateUrl: 'templates/login.html',
    controller: 'LoginCtrl'
  }).state('register', {
    url: '/register',
    templateUrl: 'templates/register.html',
    controller: 'RegisterCtrl'
  });
});

angular.module('carnatic.controllers', []).controller("LoginCtrl", function($scope) {
  return $scope.login = function(data) {
    return "placeholder";
  };
}).controller("RegisterCtrl", function($scope) {
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
          alert("Success!");
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
