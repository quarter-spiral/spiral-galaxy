# Filters

@angular.module('spiralGalaxy.filters', []).filter('humanize', ->
  (input) ->
    (input.split('-').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join(' ')
).filter('empty', ->
  (input) ->
    input.length == 0
)