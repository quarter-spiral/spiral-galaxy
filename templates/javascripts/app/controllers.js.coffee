# Controllers
@GamesController = ($scope) ->
  $scope.gamesList = (type) ->
    [
      {name: "Hallo 4", description: "This game is totally awesome", promoImage: "http://static.guim.co.uk/sys-images/Technology/Pix/pictures/2012/6/1/1338565097734/Halo-4-008.jpg",active: true}
      {name: "Super Mario World", description: "This game has guns", promoImage: "http://static.desktopnexus.com/thumbnails/22137-bigthumbnail.jpg"}
      {name: "Doom", description: "An awesome game about kittens with gun", promoImage: "http://www.pc-freak.net/images/doom2.jpg?e83a2c"}
      {name: "WipeOut", description: "So many games!!!", promoImage: "http://www.honestgamers.com/images/assets/81/W/38264/1.jpg"}
    ]


@GamesController.$inject = ["$scope"]