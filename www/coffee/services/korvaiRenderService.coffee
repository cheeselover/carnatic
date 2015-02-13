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

      return "<span class=\"modifier-bracket\">(</span> 
                #{rString} 
              <span class=\"modifier-bracket\">)</span> 
              ×#{parseInt(r.slice(lastSlash + 1))} "

    replaceRepeater: (str, r) ->
      str.replace("(#{r})", @convertRepeater(r))

    convertNadai: (n) ->
      lastSlash = n.lastIndexOf "/"
      if lastSlash is -1 then return

      nString = n.substring(0, lastSlash)
      return "<span class=\"modifier-bracket\">[</span> 
                #{nString} 
              <span class=\"modifier-bracket\">]</span> 
              → #{@numberToNadai(parseInt(n.slice(lastSlash + 1)))} "

    numberToNadai: (num) ->
      switch num
        when 3 then "thisram"
        when 4 then "chatusram"
        when 5 then "kandam"
        when 6 then "mael thisram"
        when 7 then "misram"
        when 8 then "mael chatusram"
        when 9 then "sankeernam"

    grabContent: (content) ->
      content = content.replaceAll "<br>", "\n"
      div = document.createElement("div")
      div.innerHTML = content
      content = div.textContent or div.innerText or ""

    korvaiToHTML: (korvai) ->
      if korvai is "" or korvai is null then return ""
      
      korvai = korvai.replaceAll(",", " , ").replaceAll(";", " ; ").replaceAll("\n", " \n ")
      korvaiWords = korvai.match(/([a-zA-Z]+)/g).removeDuplicates()

      for word in korvaiWords
        korvai = korvai.replaceAll "\\b#{word}\\b", " #{word}<sup>#{MatrasService.wordMatras(word)}</sup> "

      repeaters = MatrasService.findModifiers(korvai, "(", ")")
      for r in repeaters
        korvai = korvai.replace("(#{r})", @convertRepeater(r))

      nadais = MatrasService.findModifiers(korvai, "[", "]")
      for n in nadais
        korvai = korvai.replace("[#{n}]", @convertNadai(n))

      korvai = korvai.replaceAll("\n", "<br>")

      return korvai
  }