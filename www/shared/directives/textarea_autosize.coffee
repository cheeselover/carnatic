angular.module('carnatic.directives')

.directive 'textareaAutosize', ($document) ->
  return {
    restrict: 'A'
    link: (scope, element, attrs) ->
      $document.ready ->
        $(element[0]).autosize()
  }
