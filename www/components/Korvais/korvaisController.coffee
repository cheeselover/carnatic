# TODO: Find a way to reuse the downloaded data from the server
# Because I'm downloading Auth.user.korvais() twice (I think)

angular.module('carnatic.controllers')

.controller "KorvaisCtrl", ['$scope', '$ionicActionSheet', '$ionicModal', 'korvais', 
($scope, $ionicActionSheet, $ionicModal, korvais) ->
  $scope.korvais = korvais

  $ionicModal.fromTemplateUrl('components/Korvais/shareKorvaiModal.html', {
    scope: $scope
    animation: 'slide-in-up'
  }).then (modal) ->
    $scope.modal = modal

  openShareModal = ->
    $scope.modal.show()

  $scope.thalamString = (matras) ->
    switch matras
      when 32 then "adi"
      when 12 then "rupaka"
      when 14 then "misra chapu"
      when 10 then "kanda chapu"
      else "unknown"

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
        if index is 0 then openShareModal()
        true
]

.controller "KorvaiDetailCtrl", ['$scope', 'korvai', ($scope, korvai) ->
  $scope.korvai = korvai
]