# Services

# Demonstrate how to register services
# In this case it is a simple value service.
services = @angular.module "spiralGalaxy.services", []

devcenterUrl = window.qs.ENV.QS_DEVCENTER_BACKEND_URL

services.factory "games", ["$rootScope", "$cookies", "qs_commons_user", "qs_commons_http", (rootScope, cookies, user, http) ->
  http.setUserService user

  {
    allGames: ->
      http.makeRequest(
        method: 'GET'
        url: "#{devcenterUrl}/v1/public/games"
        returns: (data) -> data
      )
  }
]
