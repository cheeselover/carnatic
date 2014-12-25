angular.module('carnatic.controllers')

.controller "SearchCtrl", ($scope, userProfiles) ->
  $scope.userProfiles = userProfiles
  console.log $scope.userProfiles