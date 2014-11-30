angular.module('carnatic.factories')

.factory "Auth", ["$firebaseAuth", ($firebaseAuth) ->
  $firebaseAuth(new Firebase('https://carnatic.firebaseio.com'))
]
