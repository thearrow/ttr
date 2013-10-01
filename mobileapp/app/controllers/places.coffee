# This file is written in coffeescript - a leaner javascript - indentation matters.
# See: http://coffeescript.org/

placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"])


# Nearby: http://localhost/views/places/nearby.html
placesApp.controller "NearbyCtrl", ($scope, PlacesRestangular) ->
  $scope.placeType = 'places'
  $scope.lat = 0.0
  $scope.lng = 0.0
  $scope.locationText = ""
  $scope.latSearch = true
  $scope.searchRadius = 10 #miles

  $scope.nearbyCurrent = ->
    $scope.latSearch = true
    navigator.geolocation.getCurrentPosition onSuccess, onError

  onError = (error) ->
    navigator.notification.alert "Couldn't get your location: " + error.message
  onSuccess = (position) ->
    $scope.lat = position.coords.latitude
    $scope.lng = position.coords.longitude
    $scope.fetchPlaces()

  $scope.nearbyText = ->
    $scope.latSearch = false
    if $scope.locationText.length == 0
      navigator.notification.alert "Please enter a location (address/zip/city/etc.)"
    else
      $scope.fetchPlaces()

  $scope.fetchPlaces = ->
    $scope.loading = true
    places = PlacesRestangular.all($scope.placeType)
    if $scope.latSearch
      params = {lat: $scope.lat, lng: $scope.lng, rad: $scope.searchRadius}
    else
      params = {text: $scope.locationText, rad: $scope.searchRadius}
    places.customGETLIST("near", params).then (data) ->
      localStorage.setItem 'places', JSON.stringify(data)
      $scope.loading = false
      displayResults()

  displayResults = ->
    webView = new steroids.views.WebView("/views/places/list.html")
    steroids.layers.push
      view: webView
      navigationBar: false


# List: http://localhost/views/places/list.html?placeType=<type>&lat=<lat>&lng=<lng>
placesApp.controller "ListCtrl", ($scope) ->
  # This is populated by NearbyCtrl or SearchCtrl
  $scope.places = JSON.parse localStorage.getItem('places')

  # Helper function for opening new webviews
  $scope.open = (id) ->
    webView = new steroids.views.WebView("/views/places/show.html?id=" + id)
    steroids.layers.push
      view: webView
      navigationBar: false

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
placesApp.controller "MapCtrl", ($scope) ->
  # This is populated by NearbyCtrl or SearchCtrl
  $scope.places = JSON.parse localStorage.getItem('places')

  # Helper function for opening new webviews
  $scope.open = (id) ->
    webView = new steroids.views.WebView("/views/places/show.html?id=" + id)
    steroids.layers.push
      view: webView
      navigationBar: false

  $scope.goToList = ->
    steroids.layers.pop()

  $scope.goBack = ->
    steroids.layers.pop()



# Show: http://localhost/views/places/show.html?id=<id>
placesApp.controller "ShowCtrl", ($scope) ->
  places = JSON.parse localStorage.getItem('places')

  # +'s for conversion to int, [0] takes first (only) result of comprehension
  $scope.place = (place for place in places when +place.id is +steroids.view.params.id)[0]

  $scope.goBack = ->
    steroids.layers.pop()



# Search: http://localhost/views/places/search.html
placesApp.controller "SearchCtrl", ($scope, PlacesRestangular) ->
