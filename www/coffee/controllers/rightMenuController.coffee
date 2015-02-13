angular.module('carnatic.controllers')

.controller "RightMenuCtrl", ($scope) ->
  $scope.thalams = [
    { name: "Adi", value: 32 }
    { name: "Rupakam", value: 12 }
    { name: "Misra chapu", value: 14 }
    { name: "Kanda chapu", value: 10 }
  ]
  
  $scope.mods = [
    { name: "None", value: 0 }
    { name: "2 matras before", value: 2 }
    { name: "4 matras before", value: 4 }
    { name: "6 matras before", value: 6 }
    { name: "2 matras after", value: -2 }
    { name: "4 matras after", value: -4 }
    { name: "6 matras after", value: -6 }
  ]