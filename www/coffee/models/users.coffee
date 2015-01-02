angular.module('carnatic.models')

.factory "User", ($firebase, KorvaiList, UserProfile, Friends) ->
  class User
    constructor: (@userId) ->
    userProfile: ->
      new UserProfile(@userId).$loaded()
    korvais: ->
      new KorvaiList(@userId).$loaded()
    friends: ->
      new Friends(@userId).$loaded()