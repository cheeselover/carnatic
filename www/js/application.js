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
    }).state('tab.korvai-detail', {
      url: '/korvais/:korvaiId',
      views: {
        'tab-korvais': {
          templateUrl: 'templates/tabs/korvai-detail.html',
          controller: 'KorvaiDetailCtrl'
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

angular.module('carnatic.controllers').controller("AccountCtrl", [
  '$scope', 'Auth', function($scope, Auth) {
    return $scope.userProfile = Auth.user.userProfile();
  }
]);

angular.module('carnatic.controllers').controller("ComposeCtrl", [
  '$scope', 'Auth', 'KorvaiHelper', function($scope, Auth, KorvaiHelper) {
    $scope.createKorvai = function(korvai) {
      if (korvai.content !== "") {
        return Auth.user.korvais().$add(korvai);
      }
    };
    $scope.countMatras = function(content) {
      return $scope.matras = KorvaiHelper.countMatras(content, true);
    };
    return $scope.korvai = {
      content: "thathinkinathom,\n(thathinkinathom /2),\n(thathinkinathom /3)",
      thalam: 32,
      mod: 0
    };
  }
]);

angular.module('carnatic.controllers').controller("KorvaisCtrl", [
  '$scope', 'Auth', function($scope, Auth) {
    $scope.thalamString = function(matras) {
      switch (matras) {
        case 32:
          return "adi";
        case 12:
          return "rupaka";
        case 14:
          return "misra chapu";
        case 10:
          return "kanda chapu";
        default:
          return "unknown";
      }
    };
    $scope.korvais = Auth.user.korvais();
    return $scope.deleteKorvai = function(korvai) {
      return $scope.korvais.$remove(korvai);
    };
  }
]).controller("KorvaiDetailCtrl", [
  '$scope', '$stateParams', 'Auth', function($scope, $stateParams, Auth) {
    var korvais;
    korvais = Auth.user.korvais();
    return korvais.$loaded().then(function() {
      return $scope.korvai = korvais.$getRecord($stateParams.korvaiId);
    });
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
    $scope.loginWithGoogle = function() {
      return Auth.loginOAuth('google', {
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
              name: data.name
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
      val: '=',
      thalam: '=',
      mod: '=',
      width: '@',
      height: '@'
    },
    link: function(scope, element, attrs) {
      var arc, arcTween, background, foreground, height, svg, tau, updateTween, width;
      width = scope.width;
      height = scope.height;
      tau = 2 * Math.PI;
      arc = d3.svg.arc().innerRadius(60).outerRadius(80).startAngle(0);
      svg = d3.select(element[0]).append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
      background = svg.append("path").datum({
        endAngle: tau
      }).style("fill", "#ddd").attr("d", arc);
      foreground = svg.append("path").datum({
        endAngle: .127 * tau
      }).style("fill", "orange").attr("d", arc);
      updateTween = function(val, thalam, mod) {
        var percentage;
        percentage = (val - mod) % thalam / thalam;
        if (percentage === 0) {
          foreground.style("fill", "green");
          return foreground.transition().duration(500).call(arcTween, tau);
        } else {
          foreground.style("fill", "orange");
          return foreground.transition().duration(500).call(arcTween, percentage * tau);
        }
      };
      scope.$watch('val', function(newVal, oldVal) {
        if (newVal === oldVal) {

        } else {
          return updateTween(newVal, scope.thalam, scope.mod);
        }
      });
      scope.$watch('thalam', function(newThalam, oldThalam) {
        if (newThalam === oldThalam) {

        } else {
          return updateTween(scope.val, newThalam, scope.mod);
        }
      });
      scope.$watch('mod', function(newMod, oldMod) {
        if (newMod === oldMod) {

        } else {
          return updateTween(scope.val, scope.thalam, newMod);
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

angular.module('carnatic.directives').directive('textareaAutosize', function() {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      return $(element[0]).autosize();
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
          var provider, userProfileRef;
          if (snapshot.val() == null) {
            usersRef.child(authData.uid).set(authData);
            userProfileRef = REF.child('user_profiles').child(authData.uid);
            provider = authData.provider;
            if (provider === "facebook") {
              return userProfileRef.set({
                name: authData.facebook.displayName,
                picture: authData.facebook.cachedUserProfile.picture.data.url
              });
            } else if (provider === "google") {
              return userProfileRef.set({
                name: authData.google.displayName,
                picture: authData.google.cachedUserProfile.picture
              });
            } else {
              return userProfileRef.set({
                email: authData.password.email,
                picture: "https://www.gravatar.com/avatar/" + (CryptoJS.MD5(authData.password.email)) + "?d=retro"
              });
            }
          }
        });
      }
    });
    return AuthFactory;
  }
]);

angular.module('carnatic.factories').factory("KorvaiHelper", function() {
  return {
    findModifiers: function(str, oBracket, cBracket) {
      var chr, endPos, modifiers, openBrackets, startPos;
      endPos = -1;
      modifiers = [];
      while (true) {
        while (str.charAt(endPos + 1) !== oBracket && endPos < str.length) {
          endPos++;
        }
        if (endPos === str.length) {
          break;
        }
        openBrackets = 0;
        startPos = endPos;
        while (true) {
          chr = str.charAt(++endPos);
          if (chr === oBracket) {
            openBrackets++;
          } else if (chr === cBracket) {
            openBrackets--;
          }
          if (!(openBrackets > 0 && endPos < str.length)) {
            break;
          }
        }
        if (endPos === str.length) {
          break;
        }
        modifiers.push(str.substring(startPos + 2, endPos));
      }
      return modifiers;
    },
    repeatString: function(r) {
      var j, lastColon, rString, repeaters, _i, _len;
      lastColon = r.lastIndexOf("/");
      if (lastColon === -1) {
        return;
      }
      rString = r.substring(0, lastColon);
      repeaters = this.findModifiers(rString, "(", ")");
      for (_i = 0, _len = repeaters.length; _i < _len; _i++) {
        j = repeaters[_i];
        rString = this.replaceRepeater(rString, j);
      }
      return rString.repeat(parseInt(r.slice(lastColon + 1)));
    },
    replaceRepeater: function(str, r) {
      return str.replace("(" + r + ")", this.repeatString(r));
    },
    repeaterMatras: function(r) {
      return this.matrasWithoutModifiers(this.repeatString(r));
    },
    nadaiMatras: function(n) {
      var lastSlash, nString;
      lastSlash = n.lastIndexOf("/");
      if (lastSlash === -1) {
        return;
      }
      nString = n.substring(0, lastSlash);
      return this.countMatras(nString, false) * 4 / (parseInt(n.slice(lastSlash + 1)));
    },
    matrasWithoutModifiers: function(korvai) {
      var commas, korvaiWords, matras, semicolons, vowels, word, _i, _len;
      matras = 0;
      korvaiWords = korvai.replace(/(\r\n|\n|\r)/gm, ' ').split(' ');
      for (_i = 0, _len = korvaiWords.length; _i < _len; _i++) {
        word = korvaiWords[_i];
        vowels = word.match(/[aeiou]/g);
        if (vowels) {
          matras += vowels.length;
        }
      }
      commas = korvai.match(/,/g);
      matras += commas ? commas.length : 0;
      semicolons = korvai.match(/;/g);
      matras += semicolons ? semicolons.length * 2 : 0;
      return matras;
    },
    countMatras: function(korvai, hasNadais) {
      var matras, n, nadais, r, repeaters, _i, _j, _len, _len1;
      matras = 0;
      if (hasNadais) {
        nadais = this.findModifiers(korvai, "[", "]");
        for (_i = 0, _len = nadais.length; _i < _len; _i++) {
          n = nadais[_i];
          matras += this.nadaiMatras(n);
          korvai = korvai.replace("[" + n + "]", '');
        }
      }
      repeaters = this.findModifiers(korvai, "(", ")");
      for (_j = 0, _len1 = repeaters.length; _j < _len1; _j++) {
        r = repeaters[_j];
        matras += this.repeaterMatras(r);
        korvai = korvai.replace("(" + r + ")", '');
      }
      matras += this.matrasWithoutModifiers(korvai);
      return matras;
    }
  };
});

angular.module('carnatic.models').factory("KorvaiList", function($firebase) {
  return function(userId) {
    return $firebase(new Firebase("https://carnatic.firebaseio.com/korvais/" + userId)).$asArray();
  };
});

angular.module('carnatic.models').factory("UserProfile", function($firebase) {
  return function(userId) {
    return $firebase(new Firebase("https://carnatic.firebaseio.com/user_profiles/" + userId)).$asObject();
  };
});

angular.module('carnatic.models').factory("User", [
  '$firebase', 'KorvaiList', 'UserProfile', function($firebase, KorvaiList, UserProfile) {
    var User;
    return User = (function() {
      function User(userId) {
        this.userId = userId;
      }

      User.prototype.userProfile = function() {
        return new UserProfile(this.userId);
      };

      User.prototype.korvais = function() {
        return new KorvaiList(this.userId);
      };

      return User;

    })();
  }
]);
