# Services

# Demonstrate how to register services
# In this case it is a simple value service.
services = @angular.module "spiralGalaxy.services", []

devcenterUrl = window.qs.ENV.QS_DEVCENTER_BACKEND_URL
playercenterUrl = window.qs.ENV.QS_PLAYERCENTER_BACKEND_URL

services.factory "games", ["$rootScope", "$cookies", "qs_commons_user", "qs_commons_http", (rootScope, cookies, user, http) ->
  http.setUserService user

  {
    allGames: ->
      http.makeRequest(
        method: 'GET'
        url: "#{devcenterUrl}/v1/public/games"
        returns: (data) ->
          games = []
          for game in data.games
            game.promoImage = (game.screenshots[0] || {}).url
            games.push game
          games
      )

    myGames: ->
      http.makeRequest(
        method: 'GET',
        url: "#{playercenterUrl}/v1/#{user.currentUser().uuid}/games?venue=spiral-galaxy"
        returns: (data) ->
          games = []
          for game in data.games
            game.promoImage = (game.screenshots[0] || {}).url
            games.push game
          games
      )

    friendsGames: ->
      http.makeRequest(
        method: 'GET',
        url: "#{playercenterUrl}/v1/#{user.currentUser().uuid}/games/friends" #?venue=spiral-galaxy"
        returns: (data) ->
          games = []
          for game in data.games
            game.promoImage = (game.screenshots[0] || {}).url
            games.push game
          games
      )

    anyPlayersGames: (playerUUID) ->
      http.makeRequest(
        method: 'GET',
        url: "#{playercenterUrl}/v1/#{playerUUID}/games?venue=spiral-galaxy"
        returns: (data) ->
          games = []
          for game in data.games
            game.promoImage = (game.screenshots[0] || {}).url
            games.push game
          games
      )
  }
]



services.factory "users", ["$rootScope", "$cookies", "qs_commons_user", "qs_commons_http", (rootScope, cookies, user, http) ->
  http.setUserService user

  {
    playerDetails: (playerUUID) ->
      http.makeRequest(
        method: 'GET',
        url: "#{playercenterUrl}/v1/#{playerUUID}"
        returns: (data) ->
          playerDetails = data
          playerDetails
      )

    playerFriends: (playerUUID) ->
      http.makeRequest(
        method: 'GET',
        url: "#{playercenterUrl}/v1/#{playerUUID}/friends"
        returns: (data) ->
          playerFriends = data
          playerFriends
      )

  }
]
