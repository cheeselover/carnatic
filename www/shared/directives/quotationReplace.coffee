angular.module('carnatic.directives')

.directive 'quotationReplace', ($document) ->
  findKorvaiWords = (formattedKorvai) ->
    return formattedKorvai.match(/([a-zA-Z]+)/g).removeDuplicates().filter (word) ->
      word.length > 2

  return {
    restrict: 'A'
    link: (scope, element, attrs) ->
      $document.ready ->
        $(element[0]).keydown (e) ->
          if e.keyCode is 13
            document.execCommand('insertHTML', false, '<br><br>')
            return false

        notesData = findKorvaiWords(element[0].textContent)
        notesData = $.map notesData, (value, i) -> 
          return { key: value, name: value }

        $(element[0]).atwho
          at: '"'
          data: notesData
          displayTpl: '<li>${name}</li>'
          insertTpl: '${key}'
          startWithSpace: false

        $(element[0]).on "shown.atwho", (event) ->
          notesData = findKorvaiWords(element[0].textContent)
          notesData = $.map notesData, (value, i) -> 
            return { key: value, name: value }

          $(element[0]).atwho
            at: '"'
            data: notesData
            displayTpl: '<li>${name}</li>'
            insertTpl: '${key}'
            startWithSpace: false
  }