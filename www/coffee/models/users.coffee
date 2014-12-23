angular.module('carnatic.models')

.factory "User", ['$firebase', 'KorvaiList', 'UserProfile', 'Followings', 'Followers', 
($firebase, KorvaiList, UserProfile, Followings, Followers) ->
  class User
    constructor: (@userId) ->
    userProfile: ->
      new UserProfile(@userId).$loaded()
    korvais: ->
      new KorvaiList(@userId).$loaded()
    followers: ->
      new Followers(@userId).$loaded()
    followings: ->
      new Followings(@userId).$loaded()
]