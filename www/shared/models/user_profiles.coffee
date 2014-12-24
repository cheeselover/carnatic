angular.module('carnatic.models')

.factory "UserProfile", ($firebase, REF) ->
  (userId) ->
    $firebase(REF.child('user_profiles').child(userId)).$asObject()