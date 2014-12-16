angular.module('carnatic.models')

.factory "KorvaiList", ($firebase) ->
  (userId) ->
    $firebase(new Firebase("https://carnatic.firebaseio.com/korvais/#{userId}")).$asArray()
