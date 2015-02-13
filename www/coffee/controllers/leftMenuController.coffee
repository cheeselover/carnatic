angular.module('carnatic.controllers')

.controller "LeftMenuCtrl", ($scope, Auth) ->
  Auth.user.userProfile().then (userProfile) ->
    $scope.userProfile = userProfile