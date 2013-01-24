# Declare app level module which depends on filters, and services
@angular.module("spiralGalaxy", [
  "ngCookies"
  "qsCommons.services"
  "spiralGalaxy.filters"
  "spiralGalaxy.services"
  "spiralGalaxy.directives"
]).config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/", templateUrl: "/partials/frontpage.html"
  $routeProvider.when "/profile/:uuid", templateUrl: "/partials/profile.html"
  $routeProvider.when "/logout", templateUrl: "/partials/logout.html"
  $routeProvider.otherwise redirectTo: "/"
]
