placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"])

# Nearby: http://localhost/views/places/nearby.html
placesApp.controller "NearbyCtrl", ($scope, PlacesRestangular) ->
  $scope.placeType = 'places'

  $scope.nearbyCurrent = ->
    webView = new steroids.views.WebView("/views/places/list.html?placeType=" + $scope.placeType)
    steroids.layers.push
      view: webView
      navigationBar: false

  $scope.nearbyZip = ->
    alert "ZIP!"



# List: http://localhost/views/places/list.html
placesApp.controller "ListCtrl", ($scope, PlacesRestangular) ->

  # This will be populated with Restangular
  $scope.places = []

  # Helper function for opening new webviews
  $scope.open = (id) ->
    webView = new steroids.views.WebView("/views/places/show.html?id=" + id)
    steroids.layers.push
      view: webView
      navigationBar: false

  # Helper function for loading places data with spinner
  $scope.loadPlaces = ->
    $scope.loading = true
    places.getList().then (data) ->
      $scope.places = data
      $scope.loading = false

  # Fetch all objects from the backend (all places, restaurants only, bars only, etc.)
  places = PlacesRestangular.all(steroids.view.params.placeType)
  $scope.loadPlaces()

  # Get notified when an another webview modifies the data and reload
  window.addEventListener "message", (event) ->
    # reload data on message with reload status
    $scope.loadPlaces()  if event.data.status is "reload"

  $scope.goToMap = ->
    flip = new steroids.Animation("flipHorizontalFromRight")
    webView = new steroids.views.WebView("/views/places/map.html")
    steroids.layers.push
      view: webView
      navigationBar: false
      animation: flip

  $scope.goBack = ->
    steroids.layers.pop()



# Map: http://localhost/views/places/map.html
placesApp.controller "MapCtrl", ($scope, PlacesRestangular) ->

  # This will be populated with Restangular
  $scope.places = []

  # Helper function for opening new webviews
  $scope.open = (id) ->
    webView = new steroids.views.WebView("/views/places/show.html?id=" + id)
    steroids.layers.push
      view: webView
      navigationBar: false

  # Helper function for loading places data with spinner
  $scope.loadPlaces = ->
    $scope.loading = true
    places.getList().then (data) ->
      $scope.places = data
      $scope.loading = false

  # Fetch all objects from the backend (see app/models/places.js)
  places = PlacesRestangular.all("places")
  $scope.loadPlaces()

  # Get notified when an another webview modifies the data and reload
  window.addEventListener "message", (event) ->
    # reload data on message with reload status
    $scope.loadPlaces()  if event.data.status is "reload"

  $scope.goToList = ->
    steroids.layers.pop()

  $scope.goBack = ->
    steroids.layers.pop()
    steroids.layers.pop()



# Show: http://localhost/views/places/show.html?id=<id>
placesApp.controller "ShowCtrl", ($scope, PlacesRestangular) ->

  # Helper function for loading places data with spinner
  $scope.loadPlaces = ->
    $scope.loading = true
    place.get().then (data) ->
      $scope.place = data
      $scope.loading = false

  # Save current places id to localStorage (edit.html gets it from there)
  localStorage.setItem "currentPlacesId", steroids.view.params.id
  place = PlacesRestangular.one("places", steroids.view.params.id)
  $scope.loadPlaces()

  # When the data is modified in the edit.html, get notified and update (edit is on top of this view)
  window.addEventListener "message", (event) ->
    $scope.loadPlaces()  if event.data.status is "reload"

  $scope.goBack = ->
    steroids.layers.pop()


# Search: http://localhost/views/places/search.html
placesApp.controller "SearchCtrl", ($scope, PlacesRestangular) ->
