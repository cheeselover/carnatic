# TODO: Find a way to reuse the downloaded data from the server
# Because I'm downloading Auth.user.korvais() twice (I think)

angular.module('carnatic.controllers')

.controller "KorvaisCtrl", ['$scope', 'Auth', ($scope, Auth) ->
  $scope.thalamString = (matras) ->
    switch matras
      when 32 then "adi"
      when 12 then "rupaka"
      when 14 then "misra chapu"
      when 10 then "kanda chapu"
      else "unknown"

  $scope.korvais = Auth.user.korvais()

  $scope.deleteKorvai = (korvai) ->
    $scope.korvais.$remove(korvai)  
]

.controller "KorvaiDetailCtrl", ['$scope', '$stateParams', 'Auth', ($scope, $stateParams, Auth) ->
  korvais = Auth.user.korvais()
  korvais.$loaded().then ->
    $scope.korvai = korvais.$getRecord($stateParams.korvaiId)
]