angular.module('carnatic.controllers')

.controller "ComposeCtrl", ['$scope', 'KorvaiHelper', 'korvais', ($scope, KorvaiHelper, korvais) ->
  $scope.createKorvai = (korvai) ->
    if korvai.content isnt ""
      korvai.thalam = parseInt korvai.thalam
      korvai.mod = parseInt korvai.mod
      korvais.$add korvai

  $scope.countMatras = (content) ->
    $scope.matras = KorvaiHelper.countMatras(content, true)

  $scope.korvai =
    content: "thathinkinathom,\n(thathinkinathom /2),\n(thathinkinathom /3)"
    thalam: "32"
    mod: 0

  $scope.matras = 32
]
