angular.module('carnatic.factories')

.factory "KorvaiHelper", ->
  return {
    # findRepeaters(str) produces an array of all the content of
    # the "repeaters" in the given korvai string
    # a repeater is of the form "(thathinkinathom x3)"
    findRepeaters: (str) ->
      endPos = -1
      repeaters = []

      while true
        while str.charAt(endPos + 1) isnt "(" and endPos < str.length
          endPos++

        if endPos is str.length then break

        openBrackets = 0
        startPos = endPos

        while true
          chr = str.charAt(++endPos)
          if chr is "("
            openBrackets++
          else if chr is ")"
            openBrackets--

          break unless openBrackets > 0

        repeaters.push str.substring(startPos + 2, endPos)

      return repeaters

    # repeatString(r) consumes a repeater (as defined above)
    # and produces the repeated sequence as a string
    # e.g. (thathinkinathom x3) produces "thathinkinathom thathinkinathom thathinkinathom "
    repeatString: (r) ->
      lastColon = r.lastIndexOf "x"
      rString = r.substring(0, lastColon)
      repeaters = @findRepeaters(rString)

      for j in repeaters
        rString = @replaceRepeater(rString, j)

      return rString.repeat(parseInt(r.slice(lastColon + 1)))

    # replaceRepeater(str, r) replaces the occurrences of the repeater
    # in the given string
    replaceRepeater: (str, r) ->
      str.replace "(#{r})", @repeatString(r)

    # countMatras(korvai) counts the number of matras in the korvai
    countMatras: (korvai) ->
      repeaters = @findRepeaters(korvai)

      for r in repeaters
        korvai = @replaceRepeater(korvai, r)

      vowels = korvai.match /[aeiou,]/gi
      semicolons = korvai.match /[;]/gi
      matras = if vowels then vowels.length else 0
      matras += if semicolons then semicolons.length * 2 else 0
      return matras
  }
