angular.module('carnatic.controllers')

.controller "SearchCtrl", ($scope, Auth, REF, userProfiles) ->
  $scope.userProfiles = userProfiles

  $scope.addFriend = (userProfile) ->
    currentUserId = Auth.currentUser.uid
    if userProfile.$id isnt currentUserId
      REF.child('friends').child(currentUserId).push(userProfile.$id)
    else
      alert "You can't add yourself as a friend!"