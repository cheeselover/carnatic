angular.module('carnatic.controllers')

.controller "ComposeCtrl", ['$scope', 'Auth', ($scope, Auth) ->
  $scope.createKorvai = (korvai) ->
    if korvai.content isnt ""
      Auth.user.korvais().$add korvai.content
      korvai.content = ""

  $scope.countMatras = (korvai) ->
    vowels = korvai.match /[aeiou,]/gi
    semicolons = korvai.match /[;]/gi
    matras = if vowels then vowels.length else 0
    matras += if semicolons then semicolons.length * 2 else 0
    $scope.matras = matras

  # findRepeaters(str) produces an array of all the "repeaters" in the given korvai string
  # a repeater is of the form "{thathinkinathom:3}"
  findRepeaters = (str) ->
    endPos = -1
    repeaters = []

    while true
      while str.charAt(endPos + 1) isnt "{" and endPos < str.length
        endPos++

      if endPos == str.length then break

      openBrackets = 0
      startPos = endPos

      do {
        char = str.charAt(++pos)
        if char is "{"
          openBrackets++
        else if char is "}"
          openBrackets--
      } while openBrackets > 0

      repeaters.push str.substring(startPos, endPos + 1)

    return repeaters
]
