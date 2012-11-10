# Controllers
@GamesController = ($scope) ->
  $scope.gamesList = (type) ->
    [
      {name: "Game One", description: "This game is totally awesome", active: true}
      {name: "Game Two", description: "This game has guns"}
      {name: "Game Three", description: "An awesome game about kittens with gun"}
      {name: "Game Four", description: "So many games!!!"}
    ]


@GamesController.$inject = ["$scope"]
