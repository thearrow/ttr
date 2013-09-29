# This file is written in coffeescript - a leaner javascript - indentation matters.
# See: http://coffeescript.org/

placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"])


# Nearby: http://localhost/views/places/nearby.html
placesApp.controller "NearbyCtrl", ($scope) ->
  $scope.placeType = 'places'
  $scope.lat = 0.0
  $scope.lng = 0.0
  $scope.locationText = ""
  $scope.latSearch = true

  onError = (error) ->
    navigator.notification.alert "Couldn't get your location: " + error.message
  onSuccess = (position) ->
    $scope.lat = position.coords.latitude
    $scope.lng = position.coords.longitude
    displayResults()

  $scope.nearbyCurrent = ->
    $scope.latSearch = true
    navigator.geolocation.getCurrentPosition onSuccess, onError

  $scope.nearbyText = ->
    $scope.latSearch = false
    if $scope.locationText.length == 0
      navigator.notification.alert "Please enter a location (address/zip/city/etc.)"
    else
      displayResults()

  displayResults = ->
    if $scope.latSearch
      params = "lat=#{$scope.lat}&lng=#{$scope.lng}"
    else
      params = "loctext=#{encodeURIComponent($scope.locationText)}"
    webView = new steroids.views.WebView("/views/places/list.html?placeType=#{$scope.placeType}&#{params}")
    steroids.layers.push
      view: webView
      navigationBar: false


# List: http://localhost/views/places/list.html?placeType=<type>&lat=<lat>&lng=<lng>
placesApp.controller "ListCtrl", ($scope, PlacesRestangular) ->
  $scope.searchRadius = 10 #miles

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
    if steroids.view.params.lat
      params = {lat: steroids.view.params.lat, lng: steroids.view.params.lng, rad: $scope.searchRadius}
    else
      params = {text: decodeURIComponent(steroids.view.params.loctext), rad: $scope.searchRadius}
    places.customGETLIST("near", params).then (data) ->
      $scope.places = data
      $scope.loading = false


  # Search for nearby places from the backend (all places, restaurants only, bars only, etc.)
  # (defaults to 10-mile radius)
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
