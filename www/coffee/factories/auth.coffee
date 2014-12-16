angular.module('carnatic.factories')

.factory "Auth", ['$firebaseAuth', 'User', 'REF', ($firebaseAuth, User, REF) ->
  authRef = $firebaseAuth REF
  usersRef = REF.child 'users'

  AuthFactory = {
    createUser  : authRef.$createUser
    logout      : authRef.$unauth
    loginEmail  : authRef.$authWithPassword
    loginOAuth  : authRef.$authWithOAuthPopup
    authRef     : authRef
  }

  authRef.$onAuth (authData) ->
    if authData
      AuthFactory.currentUser = authData
      AuthFactory.user = new User(authData.uid)

      usersRef.child(authData.uid).once 'value', (snapshot) ->
        if not snapshot.val()?
          usersRef.child(authData.uid).set authData

  AuthFactory
]
