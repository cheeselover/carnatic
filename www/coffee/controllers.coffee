angular.module("starter.controllers", [])

.controller("DashCtrl", ($scope) ->
  myFirebase = new Firebase('https://blazing-fire-7995.firebaseio.com/')
  myFirebase.push {just: "testing something out"}
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
