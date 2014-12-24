angular.module('carnatic.controllers')

.controller "AccountCtrl", ['$scope', 'userProfile', 'friends', ($scope, userProfile, friends) ->
  $scope.userProfile = userProfile
  $scope.friends = friends
]