angular.module('carnatic.models')

.factory "UserProfile", ($firebase, REF) ->
  (userId) ->
    $firebase(REF.child('user_profiles').child(userId)).$asObject()

.factory "UserProfileList", ($firebase, REF) ->
  (publicOrPrivate) ->
    $firebase(REF.child('user_profiles').startAt(publicOrPrivate).endAt(publicOrPrivate)).$asArray()