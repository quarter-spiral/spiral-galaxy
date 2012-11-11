# Declare app level module which depends on filters, and services
@angular.module("spiralGalaxy", [
  "spiralGalaxy.filters"
  "spiralGalaxy.services"
  "spiralGalaxy.directives"
]).config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/", templateUrl: "/partials/frontpage.html"
  $routeProvider.when "/profile", templateUrl: "/partials/profile.html"
  $routeProvider.when "/library", templateUrl: "/partials/library.html"
  $routeProvider.otherwise redirectTo: "/"
]