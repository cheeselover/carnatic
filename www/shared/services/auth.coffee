angular.module('carnatic.factories')

.factory "Auth", ($firebaseAuth, User, REF) ->
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
          userProfileRef = REF.child('user_profiles').child(authData.uid)
          provider = authData.provider

          if provider is "facebook"
            userProfileRef.update
              name: authData.facebook.displayName
              picture: authData.facebook.cachedUserProfile.picture.data.url
          else if provider is "google"
            userProfileRef.update
              name: authData.google.displayName
              picture: authData.google.cachedUserProfile.picture
          else
            userProfileRef.update
              email: authData.password.email
              picture: "https://www.gravatar.com/avatar/#{CryptoJS.MD5(authData.password.email)}?d=retro"

  AuthFactory