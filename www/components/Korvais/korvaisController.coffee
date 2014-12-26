# TODO: Find a way to reuse the downloaded data from the server
# Because I'm downloading Auth.user.korvais() twice (I think)

angular.module('carnatic.controllers')

.controller "KorvaisCtrl", ($scope, $ionicActionSheet, $ionicModal, Auth, KorvaiList, korvais) ->
  $scope.korvais = korvais

  $ionicModal.fromTemplateUrl('components/Korvais/shareKorvaiModal.html', {
    scope: $scope
    animation: 'slide-in-up'
  }).then (modal) ->
    $scope.modal = modal

  openShareModal = (korvai) ->
    $scope.korvai = korvai
    Auth.user.friends().then (friends) ->
      $scope.friends = friends
      $scope.modal.show()

  $scope.friendClicked = ($index) ->
    $scope.friendSelected = $index

  $scope.share = ->
    new KorvaiList($scope.friends[$scope.friendSelected].$value).$loaded().then (korvais) ->
      korvais.$add $scope.korvai

  $scope.thalamString = (matras) ->
    thalam = ""
    switch matras
      when 32 then thalam = "adi"
      when 12 then thalam = "rupaka"
      when 14 then thalam = "misra chapu"
      when 10 then thalam = "kanda chapu"
      else thalam = "unknown"

    return thalam + " thalam, "

  $scope.modString = (mod) ->
    afterOrBefore = if mod < 0 then " after" else " before"
    return Math.abs(mod).toString() + afterOrBefore + " samam"

  $scope.showActions = (korvai) ->
    $ionicActionSheet.show
      buttons: [{ text: 'Share' }]
      destructiveText: 'Delete'
      titleText: 'Korvai Actions'
      cancelText: 'Cancel'

      destructiveButtonClicked: ->
        if confirm("Are you sure you want to delete this korvai?")
          $scope.korvais.$remove(korvai)
        true

      buttonClicked: (index) ->
        if index is 0 then openShareModal(korvai)
        true

.controller "KorvaiDetailCtrl", ($scope, korvai) ->
  $scope.korvai = korvai