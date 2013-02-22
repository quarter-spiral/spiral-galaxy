# Directives
@angular.module("spiralGalaxy.directives", []).directive('avoidHref', ->
  {
    link: (scope, element, attrs) ->
      element.click (event) ->
        event.preventDefault()
  }
)