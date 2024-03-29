# Controllers

betaWall = ($location, user) ->
  ->
    $location.path('/beta') unless user.currentUser()


@FrontpageController = ($scope, $location, user) ->
  $scope.redirectToBetaWall = betaWall($location, user)
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

  $scope.categories = games.categories

  $scope.selectCategory = (category) ->
    games.selectedCategory = category

  $scope.selectedCategory = ->
    games.selectedCategory

  $scope.isCategorySelected = (category) ->
    (!games.selectedCategory and !category) or (games.selectedCategory and category and games.selectedCategory.name == category.name)

  $scope.gameFilter = ->
    selectedCategory = $scope.selectedCategory()
    return {} unless selectedCategory
    {category: selectedCategory.name}

  $scope.toggle = (value) ->
    if value is true
      false
    else
      true

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


@ProfileController = ($scope, games, users, $routeParams, $location, user) ->
  $scope.redirectToBetaWall = betaWall($location, user)
  $scope.envs = window.qs.ENV

  $scope.games = {
    played: []
  }

  $scope.toggle = (value) ->
    if value is true
      false
    else
      true

  $scope.playerDetails = {}

  $scope.playerFriends = {}

  $scope.playerName = "Unknown"

  games.anyPlayersGames($routeParams.uuid).then (games) ->
    $scope.games.played = games

  users.playerDetails($routeParams.uuid).then (data) ->
    $scope.playerDetails = data

    if $scope.playerDetails.venues['spiral-galaxy']
      $scope.playerName = $scope.playerDetails.venues['spiral-galaxy'].name
    else if $scope.playerDetails.venues['facebook']
      $scope.playerName = $scope.playerDetails.venues['facebook'].name

  users.playerFriends($routeParams.uuid).then (data) ->
    $scope.playerFriends = data

@ProfileController.$inject = ["$scope", "games", "users", "$routeParams", "$location", "qs_commons_user"]