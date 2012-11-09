# Controllers
@GamesController = ($scope) ->
  $scope.topGames = [
    {name: "Game One", active: true}
    {name: "Game Two"}
    {name: "Game Three"}
  ]

@GamesController.$inject = ["$scope"]
