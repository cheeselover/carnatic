angular.module('carnatic.controllers')

.controller "KorvaisCtrl", ['$scope', 'Auth', ($scope, Auth) ->
  user = Auth.user

  $scope.korvais = user.korvais()
]
