# Controllers

@FrontpageController = ($scope, $location, user) ->
  user.currentUser()

@FrontpageController.$inject = ['$scope', '$location', 'qs_commons_user']

retrievedGames = {}
@GamesController = ($scope, games) ->
  $scope.games = {
    friends: []
    recently: []
    popular: []
    new: []
  }

  games.allGames().then (games) ->
    $scope.games.popular = games
    $scope.games.new = games

  if $scope.loggedIn
    games.myGames().then (games) ->
      $scope.games.recently = games

    games.friendsGames().then (games) ->
      $scope.games.friends = games

@GamesController.$inject = ["$scope", "games"]
