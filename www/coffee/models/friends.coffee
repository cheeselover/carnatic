angular.module('carnatic.models')

.factory "Friends", ($firebase, REF) ->
  (userId) ->
    $firebase(REF.child('friends').child(userId)).$asArray()