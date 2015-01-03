angular.module('carnatic.models')

.factory "Friends", ($firebase, REF) ->
  (userId) ->
    $firebase(REF.child("friends/#{userId}")).$asArray()