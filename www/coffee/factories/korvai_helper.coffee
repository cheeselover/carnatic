angular.module('carnatic.factories')

.factory "KorvaiHelper", ->
  return {
    # findRepeaters(str) produces an array of all the content of
    # the "repeaters" in the given korvai string
    # a repeater is of the form "(thathinkinathom x3)"
    # TODO: clean this up, it's very messy
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

          break unless openBrackets > 0 and endPos < str.length

        if endPos is str.length then break

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
    # TODO: This only works for 2nd speed, make it work for 3rd speed
    countMatras: (korvai) ->
      repeaters = @findRepeaters(korvai)
      matras = 0

      for r in repeaters
        korvai = @replaceRepeater(korvai, r)

      korvaiWords = korvai.replace(/(\r\n|\n|\r)/gm, ' ').split(' ')

      for word in korvaiWords
        vowels = word.match /[aeiou]/g

        if vowels
          length = vowels.length
          if length is 1
            matras += 1
          else
            matras += length / 2

      dashes = korvai.match /-/g
      matras += if dashes then dashes.length / 2 else 0

      commas = korvai.match /,/g
      matras += if commas then commas.length else 0

      semicolons = korvai.match /;/g
      matras += if semicolons then semicolons.length * 2 else 0

      return matras
  }
