angular.module('carnatic.controllers')

.controller "ComposeCtrl", ['$scope', 'Auth', 'KorvaiHelper', ($scope, Auth, KorvaiHelper) ->
  $scope.createKorvai = (korvai) ->
    if korvai.content isnt ""
      Auth.user.korvais().$add korvai.content
      korvai.content = ""

  $scope.countMatras = (korvai) ->
    $scope.matras = KorvaiHelper.countMatras(korvai)

]
