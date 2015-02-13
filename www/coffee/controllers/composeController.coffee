angular.module('carnatic.controllers')

.controller "ComposeCtrl", ($scope, MatrasService, KorvaiRenderService, korvais) ->
  $scope.korvai =
    content: "thathinkinathom,<br>(thathinkinathom /2),<br>(thathinkinathom /3)"
    thalam: "32"
    mod: 0

  $scope.totalMatras = 32
  matrasPerAvarthanam = parseInt($scope.korvai.thalam)
  
  $scope.avarthanams = Math.floor($scope.totalMatras / matrasPerAvarthanam)
  $scope.beats = Math.floor(($scope.totalMatras % matrasPerAvarthanam) / 4)
  $scope.matras = $scope.totalMatras % 4
  
  $scope.korvaiPreview = KorvaiRenderService.renderHTML(KorvaiRenderService.grabContent($scope.korvai.content))

  $scope.createKorvai = (korvai) ->
    content = KorvaiRenderService.grabContent(korvai.content)

    if content isnt ""
      korvais.$add {
        content: content
        thalam: parseInt korvai.thalam
        mod: parseInt korvai.mod
      }

  $scope.updateMatras = ->
    $scope.totalMatras = MatrasService.countMatras($scope.korvai.content, true)

    $scope.avarthanams = Math.floor($scope.totalMatras / matrasPerAvarthanam)
    $scope.beats = Math.floor(($scope.totalMatras % matrasPerAvarthanam) / 4)
    $scope.matras = $scope.totalMatras % 4

    $scope.korvaiPreview = KorvaiRenderService.renderHTML(KorvaiRenderService.grabContent($scope.korvai.content))

    $scope.$apply()

  