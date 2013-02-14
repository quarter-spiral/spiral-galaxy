# Filters

@angular.module('spiralGalaxy.filters', []).filter('humanize', ->
  (input) ->
    (input.split('-').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join(' ')
).filter('empty', ->
  (input) ->
    input.length == 0
).filter('include', ->
  (haystack, needle) ->
    needle in haystack
).filter('eitherOr', ->
  (thisIsTrue, doThis, doThatOtherThing) ->
    if thisIsTrue then doThis else doThatOtherThing
).filter('or', ->
  (thiz, that) ->
    thiz or that
).filter('enabledOnSpiralGalaxy', ->
  (games) ->
    gamesEnabledOnSpiralGalaxy = []
    for game in games
      gamesEnabledOnSpiralGalaxy.push(game) if game.venues.indexOf('spiral-galaxy') isnt -1
    gamesEnabledOnSpiralGalaxy
)