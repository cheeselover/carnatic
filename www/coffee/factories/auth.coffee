angular.module('carnatic.factories')

.factory "Auth", ['$firebaseAuth', ($firebaseAuth) ->
  authRef = $firebaseAuth new Firebase('https://carnatic.firebaseio.com')
  usersRef = new Firebase "https://carnatic.firebaseio.com/users"

  authRef.$onAuth (authData) ->
    if authData
      usersRef.child(authData.uid).once 'value', (snapshot) ->
        if not snapshot.val()?
          usersRef.child(authData.uid).set authData

  return {
    currentUser : authRef.$getAuth()
    createUser  : authRef.$createUser
    logout      : authRef.$unauth
    loginEmail  : authRef.$authWithPassword
    loginOAuth  : authRef.$authWithOAuthPopup
    authRef     : authRef
  }
]
