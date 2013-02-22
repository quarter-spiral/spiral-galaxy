# 0.0.26

* Adds asset caching
* Moves from Brochure to Sprockets

# 0.0.25

* now with pretty beta wall

# 0.0.24

* tweaked credit line presentation

# 0.0.23

* Adds credits
* Removes games from SG that are not enabled for SG

# 0.0.22

* Makes category filters real
* Fixes remaining bugs for player profiles when not logged in

# 0.0.21

* Fixes player profiles for not logged in players

# 0.0.20

* Adds beta wall
* Retires password protection

# 0.0.19

* Reverts password protection

# 0.0.18

* Removes http basic auth protection on production

# 0.0.17

* Makes embed codes available from the games list

# 0.0.16

* Fixes typo in controller code

# 0.0.15

* Fixes Bug where a players name on the profile is not displayed

# 0.0.14

* Removes remaining UI stubs (like profile text, etc)
* Adds permanent profile urls for all users
* Hides info and game lists when n/a rather than showing empty

# 0.0.13

* Makes it possible to be redirected to a game directly after login
* Adds a logout route in Angular to be called from external sources

# 0.0.12

* Makes playing games possible when not logged in

# 0.0.11

* Adds Newrelic monitoring and ping middleware

# 0.0.10

* Fixes bug to run on Heroku

# 0.0.9

* Fixes a bug that caused all games to be shown in top spot when logged out
* Added "no games played yet" message

# 0.0.8

* Makes promotional random games appear next to each other when logged out
* Shows/Hides promotional spots at the top if there are/aren't friend's and played games
* Hides play now button if game not available on spiral-galaxy
* Adds a info message to the recently played block if no games played yet
* Adds dynamic venue links to each game
* Fixes missing screenshot for games

# 0.0.7

* Removes unnecessary app filters in the UI

# 0.0.6

* Makes "Play Now" links work

# 0.0.5

* Adds OAuth token to the signed info passed to the canvas-app
* Removes debug left overs

# 0.0.4

* Adds the ``/play/:uuid:`` endpoint to play games
* Shows friends from all venues

# 0.0.3

* Bumps angular-commons-middleware to fix a bug retrieving games when not logged in

# 0.0.2

* The beginning
