# Declare app level module which depends on filters, and services
@angular.module("spiralGalaxy", [
  "ngCookies"
  "qsCommons.services"
  "spiralGalaxy.filters"
  "spiralGalaxy.services"
  "spiralGalaxy.directives"
]).config(["$routeProvider", "$locationProvider", ($routeProvider, $location) ->
  $routeProvider.when "/", templateUrl: "/partials/frontpage.html"
  $routeProvider.when "/profile/:uuid", templateUrl: "/partials/profile.html"
  $routeProvider.when "/logout", templateUrl: "/partials/logout.html"
  $routeProvider.when "/beta", templateUrl: "/partials/beta.html"
  $routeProvider.otherwise redirectTo: "/"

]).run ($rootScope, $location, $timeout, qs_commons_user) ->
  $rootScope.$on '$locationChangeStart', (e, next, current) ->
    unless next.match(/#\/beta$/) || qs_commons_user.currentUser()
      e.preventDefault()
      $timeout(->
        $location.path('/beta')
      , 0)
