angular.module('carnatic', ['ionic', 'firebase', 'carnatic.controllers', 'carnatic.factories', 'carnatic.models', 'carnatic.directives']).run([
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
        return Auth.authRef.$waitForAuth().then(function(user) {
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
]).value('REF', new Firebase("https://carnatic.firebaseio.com/"));

angular.module('carnatic.controllers', []);

angular.module('carnatic.factories', []);

angular.module('carnatic.models', []);

angular.module('carnatic.directives', []);

String.prototype.repeat = function(num) {
  return new Array(num + 1).join(this);
};

angular.module('carnatic.controllers').controller("AccountCtrl", function($scope) {
  return "placeholder";
});

angular.module('carnatic.controllers').controller("ComposeCtrl", [
  '$scope', 'Auth', 'KorvaiHelper', function($scope, Auth, KorvaiHelper) {
    $scope.createKorvai = function(korvai) {
      if (korvai.content !== "") {
        Auth.user.korvais().$add(korvai.content);
        return korvai.content = "";
      }
    };
    return $scope.countMatras = function(korvai) {
      return $scope.matras = KorvaiHelper.countMatras(korvai);
    };
  }
]);

angular.module('carnatic.controllers').controller("KorvaisCtrl", [
  '$scope', 'Auth', function($scope, Auth) {
    var user;
    user = Auth.user;
    return $scope.korvais = user.korvais();
  }
]);

angular.module('carnatic.controllers').controller("LoginCtrl", [
  '$scope', '$state', 'Auth', function($scope, $state, Auth) {
    $scope.auth = Auth;
    $scope.user = $scope.auth.currentUser;
    $scope.loginWithEmail = function(data) {
      return Auth.loginEmail({
        email: data.email,
        password: data.password
      }, {
        remember: "sessionOnly"
      }).then(function(authData) {
        return $state.go('tab.compose');
      })["catch"](function(error) {
        return alert("Authentication failed: " + error);
      });
    };
    $scope.loginWithFacebook = function() {
      return Auth.loginOAuth('facebook', {
        remember: "sessionOnly"
      }).then(function(authData) {
        return $state.go('tab.compose');
      })["catch"](function(error) {
        return alert("Authentication failed: " + error);
      });
    };
    return $scope.logout = function() {
      $scope.auth.logout();
      return location.reload();
    };
  }
]);

angular.module('carnatic.controllers').controller("RegisterCtrl", [
  '$scope', '$state', 'Auth', 'REF', function($scope, $state, Auth, REF) {
    return $scope.register = function(data) {
      if (data.password === data.password_confirm) {
        return Auth.createUser(data.email, data.password)["catch"](function(error) {
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
          }
        }).then(function() {
          return Auth.loginEmail({
            email: data.email,
            password: data.password
          }, {
            remember: "sessionOnly"
          }).then(function(authData) {
            REF.child("user_profiles").child(authData.uid).set({
              username: data.username,
              name: data.name,
              email: data.email
            });
            return $state.go('tab.compose');
          })["catch"](function(error) {
            return alert("Authentication failed: " + error);
          });
        });
      } else {
        return alert("Password did not match confirmation.");
      }
    };
  }
]);

angular.module('carnatic.directives').directive('arcTween', function() {
  return {
    restrict: 'E',
    scope: {
      val: '='
    },
    link: function(scope, element, attrs) {
      var arc, arcTween, background, foreground, height, svg, tau, width;
      width = 500;
      height = 360;
      tau = 2 * Math.PI;
      arc = d3.svg.arc().innerRadius(60).outerRadius(80).startAngle(0);
      svg = d3.select(element[0]).append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
      background = svg.append("path").datum({
        endAngle: tau
      }).style("fill", "#ddd").attr("d", arc);
      foreground = svg.append("path").datum({
        endAngle: .75 * tau
      }).style("fill", "orange").attr("d", arc);
      scope.$watch('val', function(newVal, oldVal) {
        if (!newVal || newVal === oldVal) {

        } else {
          return foreground.transition().duration(500).call(arcTween, newVal / 100 * tau);
        }
      });
      return arcTween = function(transition, newAngle) {
        return transition.attrTween("d", function(d) {
          var interpolate;
          interpolate = d3.interpolate(d.endAngle, newAngle);
          return function(t) {
            d.endAngle = interpolate(t);
            return arc(d);
          };
        });
      };
    }
  };
});

angular.module('carnatic.factories').factory("Auth", [
  '$firebaseAuth', 'User', 'REF', function($firebaseAuth, User, REF) {
    var AuthFactory, authRef, usersRef;
    authRef = $firebaseAuth(REF);
    usersRef = REF.child('users');
    AuthFactory = {
      createUser: authRef.$createUser,
      logout: authRef.$unauth,
      loginEmail: authRef.$authWithPassword,
      loginOAuth: authRef.$authWithOAuthPopup,
      authRef: authRef
    };
    authRef.$onAuth(function(authData) {
      if (authData) {
        AuthFactory.currentUser = authData;
        AuthFactory.user = new User(authData.uid);
        return usersRef.child(authData.uid).once('value', function(snapshot) {
          if (snapshot.val() == null) {
            return usersRef.child(authData.uid).set(authData);
          }
        });
      }
    });
    return AuthFactory;
  }
]);

angular.module('carnatic.factories').factory("KorvaiHelper", function() {
  return {
    findRepeaters: function(str) {
      var chr, endPos, openBrackets, repeaters, startPos;
      endPos = -1;
      repeaters = [];
      while (true) {
        while (str.charAt(endPos + 1) !== "(" && endPos < str.length) {
          endPos++;
        }
        if (endPos === str.length) {
          break;
        }
        openBrackets = 0;
        startPos = endPos;
        while (true) {
          chr = str.charAt(++endPos);
          if (chr === "(") {
            openBrackets++;
          } else if (chr === ")") {
            openBrackets--;
          }
          if (!(openBrackets > 0)) {
            break;
          }
        }
        repeaters.push(str.substring(startPos + 2, endPos));
      }
      return repeaters;
    },
    repeatString: function(r) {
      var j, lastColon, rString, repeaters, _i, _len;
      lastColon = r.lastIndexOf("x");
      rString = r.substring(0, lastColon);
      repeaters = this.findRepeaters(rString);
      for (_i = 0, _len = repeaters.length; _i < _len; _i++) {
        j = repeaters[_i];
        rString = this.replaceRepeater(rString, j);
      }
      return rString.repeat(parseInt(r.slice(lastColon + 1)));
    },
    replaceRepeater: function(str, r) {
      return str.replace("(" + r + ")", this.repeatString(r));
    },
    countMatras: function(korvai) {
      var matras, r, repeaters, semicolons, vowels, _i, _len;
      repeaters = this.findRepeaters(korvai);
      for (_i = 0, _len = repeaters.length; _i < _len; _i++) {
        r = repeaters[_i];
        korvai = this.replaceRepeater(korvai, r);
      }
      vowels = korvai.match(/[aeiou,]/gi);
      semicolons = korvai.match(/[;]/gi);
      matras = vowels ? vowels.length : 0;
      matras += semicolons ? semicolons.length * 2 : 0;
      return matras;
    }
  };
});

angular.module('carnatic.models').factory("KorvaiList", function($firebase) {
  return function(userId) {
    return $firebase(new Firebase("https://carnatic.firebaseio.com/korvais/" + userId)).$asArray();
  };
});

angular.module('carnatic.models').factory("User", [
  '$firebase', 'KorvaiList', function($firebase, KorvaiList) {
    var User;
    return User = (function() {
      function User(userId) {
        this.userId = userId;
      }

      User.prototype.korvais = function() {
        return new KorvaiList(this.userId);
      };

      return User;

    })();
  }
]);
