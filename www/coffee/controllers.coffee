angular.module("starter.controllers", [])

.controller("DashCtrl", ($scope) ->

)

.controller("FriendsCtrl", ($scope, Friends) ->
  $scope.friends = Friends.all()
)

.controller("FriendDetailCtrl", ($scope, $stateParams, Friends) ->
  $scope.friend = Friends.get($stateParams.friendId)
)

.controller("AccountCtrl", ($scope) ->
  test_str = "thaka thakida thakathimi"
  $scope.korvai = test_str.length - test_str.replace(/[aeiou]/g, '').length
)
