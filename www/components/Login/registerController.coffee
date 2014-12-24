angular.module('carnatic.controllers')

.controller "RegisterCtrl", ['$scope', '$state', 'Auth', 'REF', ($scope, $state, Auth, REF) ->
  $scope.register = (data) ->
    if data.password == data.password_confirm
      Auth.createUser(data.email, data.password).catch (error) ->
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
      .then ->
        Auth.loginEmail({
          email: data.email
          password: data.password
        }, { remember: "sessionOnly" })
          .then (authData) ->
            REF.child("user_profiles").child(authData.uid).set
              name: data.name
              
            $state.go 'app.compose'
          .catch (error) ->
            alert "Authentication failed: #{error}"

    else
      alert "Password did not match confirmation."
]
