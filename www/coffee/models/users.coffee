angular.module('carnatic.models')

.factory "User", ['$firebase', '$q', 'KorvaiList', 'UserProfile', ($firebase, $q, KorvaiList, UserProfile) ->
  class User
    constructor: (@userId) ->
    userProfile: ->
      new UserProfile(@userId)
    korvais: ->
      new KorvaiList(@userId).$loaded()
]