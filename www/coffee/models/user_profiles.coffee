angular.module('carnatic.models')

.factory "UserProfile", ($firebase) ->
  (userId) ->
    $firebase(new Firebase("https://carnatic.firebaseio.com/user_profiles/#{userId}")).$asObject()