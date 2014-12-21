angular.module('carnatic.factories')

.factory "KorvaiHelper", ->
  return {
    # findModifiers(str, oBracket, cBracket) produces an array of all the
    # content of the "modifiers" in the given korvai string, where a modifier
    # is either a repeater or nadai
    # a repeater is of the form "(thathinkinathom /3)" with parentheses
    # a nadai is of the form "[thathinkinathom /3]" with square brackets
    # TODO: clean this up, it's very messy
    findModifiers: (str, oBracket, cBracket) ->
      endPos = -1
      modifiers = []

      while true
        while str.charAt(endPos + 1) isnt oBracket and endPos < str.length
          endPos++

        if endPos is str.length then break

        openBrackets = 0
        startPos = endPos

        while true
          chr = str.charAt(++endPos)
          if chr is oBracket
            openBrackets++
          else if chr is cBracket
            openBrackets--

          break unless openBrackets > 0 and endPos < str.length

        if endPos is str.length then break

        modifiers.push str.substring(startPos + 2, endPos)

      return modifiers

    # repeatString(r) consumes a repeater (as defined above)
    # and produces the repeated sequence as a string
    # e.g. (thathinkinathom /3) produces "thathinkinathom thathinkinathom thathinkinathom "
    repeatString: (r) ->
      lastColon = r.lastIndexOf "/"
      if lastColon is -1 then return

      rString = r.substring(0, lastColon)
      repeaters = @findModifiers(rString, "(", ")")

      for j in repeaters
        rString = @replaceRepeater(rString, j)

      return rString.repeat(parseInt(r.slice(lastColon + 1)))

    # replaceRepeater(str, r) replaces the occurrences of the repeater
    # in the given string
    replaceRepeater: (str, r) ->
      str.replace "(#{r})", @repeatString(r)

    # repeaterMatras(r) counts the number of matras in the given repeater
    repeaterMatras: (r) ->
      @matrasWithoutModifiers(@repeatString(r))

    nadaiMatras: (n) ->
      lastSlash = n.lastIndexOf "/"
      if lastSlash is -1 then return

      nString = n.substring(0, lastSlash)

      @countMatras(nString, false) * 4 / (parseInt(n.slice(lastSlash + 1)))

    matrasWithoutModifiers: (korvai) ->
      matras = 0
      korvaiWords = korvai.replace(/(\r\n|\n|\r)/gm, ' ').split(' ')

      for word in korvaiWords
        vowels = word.match /[aeiou]/g
        if vowels
          matras += vowels.length
          # length = vowels.length
          # if length is 1
          #   matras += 2
          # else
          #   matras += length

      commas = korvai.match /,/g
      matras += if commas then commas.length else 0

      semicolons = korvai.match /;/g
      matras += if semicolons then semicolons.length * 2 else 0

      return matras

    # countMatras(korvai) counts the number of matras in the korvai
    # TODO: this only works for 2nd speed
    countMatras: (korvai, hasNadais) ->
      matras = 0

      if hasNadais
        nadais = @findModifiers(korvai, "[", "]")

        for n in nadais
          matras += @nadaiMatras(n)
          korvai = korvai.replace "[#{n}]", ''

      repeaters = @findModifiers(korvai, "(", ")")

      for r in repeaters
        matras += @repeaterMatras(r)
        korvai = korvai.replace "(#{r})", ''

      matras += @matrasWithoutModifiers(korvai)
      return matras
  }
