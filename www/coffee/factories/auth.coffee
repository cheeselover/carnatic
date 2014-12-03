angular.module('carnatic.factories')

.factory "Auth", ["$firebaseAuth", ($firebaseAuth) ->
  authRef = $firebaseAuth(new Firebase('https://carnatic.firebaseio.com'))
  return {
    currentUser: authRef.$getAuth()
    logout: authRef.$unauth
    loginEmail: authRef.$authWithPassword
    loginOAuth: authRef.$authWithOAuthPopup
    authRef: authRef
  }
]
