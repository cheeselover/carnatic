angular.module('carnatic.directives')

.directive 'textareaAutosize', ->
  return {
    restrict: 'A'
    link: (scope, element, attrs) ->
      $(element[0]).autosize()
  }
