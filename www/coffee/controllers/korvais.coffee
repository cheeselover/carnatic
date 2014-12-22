# TODO: Find a way to reuse the downloaded data from the server
# Because I'm downloading Auth.user.korvais() twice (I think)

angular.module('carnatic.controllers')

.controller "KorvaisCtrl", ['$scope', 'korvais', ($scope, korvais) ->
  $scope.thalamString = (matras) ->
    switch matras
      when 32 then "adi"
      when 12 then "rupaka"
      when 14 then "misra chapu"
      when 10 then "kanda chapu"
      else "unknown"

  $scope.korvais = korvais

  $scope.deleteKorvai = (korvai) ->
    $scope.korvais.$remove(korvai)  
]

.controller "KorvaiDetailCtrl", ['$scope', 'korvai', ($scope, korvai) ->
  $scope.korvai = korvai
]