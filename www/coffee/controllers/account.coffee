angular.module('carnatic.controllers')

.controller "AccountCtrl", ['$scope', 'userProfile', ($scope, userProfile) ->
  $scope.userProfile = userProfile
]