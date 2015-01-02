angular.module('carnatic.controllers')

.controller "ComposeCtrl", ($scope, MatrasService, korvais) ->
  $scope.createKorvai = (korvai) ->
    content = korvai.content.replaceAll "<br>", "\n"
    div = document.createElement("div")
    div.innerHTML = content
    content = div.textContent or div.innerText or ""

    if korvai.content isnt ""
      korvais.$add {
        content: content
        thalam: parseInt korvai.thalam
        mod: parseInt korvai.mod
      }

  $scope.countMatras = (content) ->
    $scope.matras = MatrasService.countMatras(content, true)

  $scope.korvai =
    content: "thathinkinathom,<br>(thathinkinathom /2),<br>(thathinkinathom /3)"
    thalam: "32"
    mod: 0

  $scope.matras = 32