angular.module('carnatic.services')

.factory 'KorvaiRenderService', ($sce, MatrasService) ->
  return {
    renderHTML: (korvai) ->
      $sce.trustAsHtml(@korvaiToHTML(korvai))

    convertRepeater: (r) ->
      lastSlash = r.lastIndexOf "/"
      if lastSlash is -1 then return

      rString = r.substring(0, lastSlash)
      repeaters = MatrasService.findModifiers(rString, "(", ")")

      for j in repeaters
        rString = @replaceRepeater(rString, j)

      return "( #{rString} ) ×#{parseInt(r.slice(lastSlash + 1))} "

    replaceRepeater: (str, r) ->
      str.replace("(#{r})", @convertRepeater(r))

    convertNadai: (n) ->
      lastSlash = n.lastIndexOf "/"
      if lastSlash is -1 then return

      nString = n.substring(0, lastSlash)
      return "[ #{nString} ] → #{@numberToNadai(parseInt(n.slice(lastSlash + 1)))} "

    numberToNadai: (num) ->
      switch num
        when 3 then "thisram"
        when 4 then "chatusram"
        when 5 then "kandam"
        when 6 then "mael thisram"
        when 7 then "misram"
        when 8 then "mael chatusram"
        when 9 then "sankeernam"

    korvaiToHTML: (korvai) ->
      korvai = " #{korvai} "
      repeaters = MatrasService.findModifiers(korvai, "(", ")")

      for r in repeaters
        korvai = korvai.replace("(#{r})", @convertRepeater(r))

      # korvai = korvai.replaceAll("\n", " <br> ").replaceAll(",", " , ").replaceAll(";", " ; ")
      # korvaiWords = korvai.split(" ").removeDuplicates().filter (word) ->
      #   badChars = word.match(/[^a-z]/g)
      #   return word isnt "" and (not badChars or badChars.length is 0)
      korvai = korvai.replaceAll(",", " , ").replaceAll(";", " ; ").replaceAll("\n", " \n ")
      korvaiWords = korvai.match(/([a-zA-Z]+)/g).removeDuplicates()

      for word in korvaiWords
        korvai = korvai.replaceAll " #{word} ", " #{word}<sup>#{MatrasService.wordMatras(word)}</sup> "

      nadais = MatrasService.findModifiers(korvai, "[", "]")

      for n in nadais
        korvai = korvai.replace("[#{n}]", @convertNadai(n))

      korvai = korvai.replaceAll "\n", "<br>"

      return korvai
  }