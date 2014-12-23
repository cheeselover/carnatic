angular.module('carnatic.models')

.factory "KorvaiList", ($firebase, REF) ->
  (userId) ->
    $firebase(REF.child('korvais').child(userId)).$asArray()
