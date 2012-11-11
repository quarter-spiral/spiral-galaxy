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

  games.allGames().then (data) ->
    games = data.games

    $scope.games.friends = games
    $scope.games.recently = games
    $scope.games.popular = games
    $scope.games.new = games

@GamesController.$inject = ["$scope", "games"]
