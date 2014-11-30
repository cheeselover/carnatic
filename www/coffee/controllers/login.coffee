angular.module('carnatic.controllers')

.controller "LoginCtrl", ['$scope', 'Auth', ($scope, Auth) ->
  $scope.auth = Auth
  $scope.user = $scope.auth.$getAuth()

  $scope.login = (data) ->
    Auth.$authWithPassword({
      email: data.email
      password: data.password
    }, { remember: "sessionOnly" })
    .then (authData) ->
      location.reload()
    .catch (error) ->
      alert "Authentication failed: #{error}"

  $scope.logout = ->
    $scope.auth.$unauth()
    location.reload()
]

