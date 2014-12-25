angular.module('carnatic.controllers')

.controller "AccountCtrl", ['$scope', 'userProfile', 'friends', ($scope, userProfile, friends) ->
  $scope.userProfile = userProfile
  $scope.friends = friends

  $scope.updateProfile = (profile) ->
    if profile.name isnt ""
      profile.$priority = if profile.is_public then "public" else "private"
      profile.$save()
      alert "Updated profile!"
    else
      alert "Name cannot be blank."
]