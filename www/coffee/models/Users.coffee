angular.module('carnatic.models')

.factory "User", ['$firebase', 'KorvaiList', ($firebase, KorvaiList) ->
  class User
    constructor: (@userId) ->

    korvais: ->
      new KorvaiList(@userId)
]
