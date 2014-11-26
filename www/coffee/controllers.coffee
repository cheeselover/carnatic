angular.module("carnatic.controllers", [])

.controller("ComposeCtrl", ($scope) ->
  myFirebase = new Firebase('https://blazing-fire-7995.firebaseio.com/')
  myFirebase.push {just: "testing something out"}
)

.controller("KorvaisCtrl", ($scope, Korvais) ->
  $scope.korvais = Korvais.all()
)

.controller("KorvaiDetailCtrl", ($scope, $stateParams, Korvais) ->
  $scope.korvai = Korvais.get($stateParams.korvaiId)
)

.controller("AccountCtrl", ($scope) ->
  test_str = "thaka thakida thakathimi"
  $scope.korvai = test_str.length - test_str.replace(/[aeiou]/g, '').length
)
