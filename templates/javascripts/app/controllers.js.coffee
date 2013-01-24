# Controllers

@FrontpageController = ($scope, $location, user) ->
  user.currentUser()

@FrontpageController.$inject = ['$scope', '$location', 'qs_commons_user']

retrievedGames = {}

@GamesController = ($scope, games) ->
  $scope.envs = window.qs.ENV

  $scope.games = {
    friends: []
    recently: []
    popular: []
    all: []
  }

  games.allGames().then (games) ->
    $scope.games.all = games

  if $scope.loggedIn
    games.myGames().then (games) ->
      $scope.games.recently = games

    games.friendsGames().then (games) ->
      $scope.games.friends = games

@GamesController.$inject = ["$scope", "games"]

@LogoutController = ($scope, user) ->
  $scope.logout = ->
    user.logout()
@LogoutController.$inject = ["$scope", "qs_commons_user"]


@ProfileController = ($scope, games, users, $routeParams) ->
  $scope.envs = window.qs.ENV

  $scope.games = {
    played: []
  }

  $scope.playerDetails = {}

  $scope.playerFriends = {}

  $scope.playerName = "unknown"

  games.anyPlayersGames($routeParams.uuid).then (games) ->
    $scope.games.played = games

  users.playerDetails($routeParams.uuid).then (data) ->
    $scope.playerDetails = data
    if playerDetails.venues.spiral-galaxy
      $scope.playerName = playerDetails.venues.spiral-galaxy.name
    else if playerDetails.venues.facebook
      $scope.playerName = playerDetails.venues.facebook.name


  users.playerFriends($routeParams.uuid).then (data) ->
    $scope.playerFriends = data

@ProfileController.$inject = ["$scope", "games", "users", "$routeParams"]