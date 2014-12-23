angular.module('carnatic.models')

.factory "Followers", ($firebase, REF) ->
  (userId) ->
    $firebase(REF.child('followers').child(userId)).$asObject()

.factory "Followings", ($firebase, REF) ->
  (userId) ->
    $firebase(REF.child('followings').child(userId)).$asObject()