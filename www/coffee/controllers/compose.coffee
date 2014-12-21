angular.module('carnatic.controllers')

.controller "ComposeCtrl", ['$scope', 'Auth', 'KorvaiHelper', ($scope, Auth, KorvaiHelper) ->
  $scope.createKorvai = (korvai) ->
    if korvai.content isnt ""
      Auth.user.korvais().$add korvai

  $scope.countMatras = (content) ->
    $scope.matras = KorvaiHelper.countMatras(content, true)

  $scope.korvai =
    content: "thathinkinathom,\n(thathinkinathom /2),\n(thathinkinathom /3)"
    thalam: 32
    mod: 0
]
