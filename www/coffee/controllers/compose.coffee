angular.module('carnatic.controllers')

.controller "ComposeCtrl", ['$scope', 'Auth', ($scope, Auth) ->
  $scope.createKorvai = (korvai) ->
    if korvai.content isnt ""
      Auth.user.korvais().$add korvai.content
      korvai.content = ""

  $scope.countMatras = (content) ->
    vowels = content.match /[aeiou]/gi
    $scope.matras = if vowels then vowels.length else 0
]
