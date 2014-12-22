angular.module('carnatic.controllers')

.controller "AccountCtrl", ['$scope', 'Auth', ($scope, Auth) ->
  $scope.userProfile = Auth.user.userProfile()
]