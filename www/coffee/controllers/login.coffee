angular.module('carnatic.controllers')

.controller "LoginCtrl", ['$scope', 'Auth', ($scope, Auth) ->
  $scope.auth = Auth
  $scope.user = $scope.auth.$getAuth()
  window.w00t = $scope.user

  $scope.loginWithEmail = (data) ->
    Auth.$authWithPassword({
      email: data.email
      password: data.password
    }, { remember: "sessionOnly" })
    .then (authData) ->
      console.log authData
      location.assign "/#/tab/compose"
    .catch (error) ->
      alert "Authentication failed: #{error}"

  $scope.loginWithFacebook = ->
    Auth.$authWithOAuthPopup('facebook',
    (error, authData) ->
      if error?
        alert "Authentication failed: #{error}"
      else
        console.log authData

    , { remember: "sessionOnly" })

  $scope.logout = ->
    $scope.auth.$unauth()
    location.reload()
]
