angular.module('carnatic.factories')

.factory "KorvaiHelper", ->
  return {
    # findRepeaters(str) produces an array of all the content of
    # the "repeaters" in the given korvai string
    # a repeater is of the form "{thathinkinathom:3}"
    findRepeaters: (str) ->
      endPos = -1
      repeaters = []

      while true
        while str.charAt(endPos + 1) isnt "{" and endPos < str.length
          endPos++

        if endPos is str.length then break

        openBrackets = 0
        startPos = endPos

        while true
          chr = str.charAt(++endPos)
          if chr is "{"
            openBrackets++
          else if chr is "}"
            openBrackets--

          break unless openBrackets > 0

        repeaters.push str.substring(startPos + 2, endPos)

      return repeaters

    # repeatString(repeater) consumes a repeater (as defined above)
    # and produces the repeated sequence as a string
    # e.g. {thathinkinathom :3} produces "thathinkinathom thathinkinathom thathinkinathom"
    repeatString: (repeater) ->
      lastColon = repeater.lastIndexOf ":"
      return repeater.substring(0, lastColon)
        .repeat(parseInt(repeater.slice(lastColon + 1)))

    # matrasPerLine(str) produces the number of matras in the given korvai string
    # the string must NOT contain repeaters
    matrasPerLine: (line) ->
      repeaters = @findRepeaters(line)

      for r in repeaters
        repeatedString = @repeatString(r)
        line = line.replace("{" + r + "}", repeatedString)

      vowels = line.match /[aeiou,]/gi
      semicolons = line.match /[;]/gi
      matras = if vowels then vowels.length else 0
      matras += if semicolons then semicolons.length * 2 else 0
      return matras

    countMatras: (korvai) ->
      matras = 0
      lines = korvai.match /([^\r\n]+)/g

      for l in lines
        matras += @matrasPerLine(l)

      return matras
  }
