angular.module('carnatic.controllers', [])

.controller "LoginCtrl", ($scope) ->
  $scope.login = (data) ->
    "placeholder"

.controller "RegisterCtrl", ($scope) ->
  ref = new Firebase 'https://carnatic.firebaseio.com'

  $scope.register = (data) ->
    if data.password == data.password_confirm
      ref.createUser {
        email: data.email
        password: data.password
      }, (error) ->
        if error
          switch error.code
            when "EMAIL_TAKEN"
              alert "Email already in use."
              break
            when "INVALID EMAIL"
              alert "Email not valid"
              break
            else
              alert "Error creating user: #{error}"
        else
          alert "Success!"
          ref.child("users").child(data.username).set
            username: data.username
            name: data.name
            email: data.email
    else
      alert "Password did not match confirmation."
