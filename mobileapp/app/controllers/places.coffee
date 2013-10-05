# This file is written in coffeescript - a leaner javascript - indentation matters.
# See: http://coffeescript.org/

placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"])


# Nearby: http://localhost/views/places/nearby.html
placesApp.controller "NearbyCtrl", ($scope) ->
  $scope.type = 'places'
  $scope.lat = 0.0
  $scope.lng = 0.0
  $scope.rad = 10 #miles
  $scope.locationText = ""

  $scope.nearbyCurrent = ->
    navigator.geolocation.getCurrentPosition onSuccess, onError

  onError = (error) ->
    navigator.notification.alert "Couldn't get your location: " + error.message
  onSuccess = (position) ->
    $scope.lat = position.coords.latitude
    $scope.lng = position.coords.longitude
    displayResults()

  $scope.nearbyText = ->
    if $scope.locationText.length == 0
      navigator.notification.alert "Please enter a location (address/zip/city/etc.)"
    else
      geocodeAddress()

  geocodeAddress = ->
    geocoder = new google.maps.Geocoder()
    geocoder.geocode
      address: $scope.locationText
    , (results, status) ->
      if status is google.maps.GeocoderStatus.OK
        $scope.lat = results[0].geometry.location.lat()
        $scope.lng = results[0].geometry.location.lng()
        displayResults()
      else
        console.log status

  displayResults = ->
    params = "?placetype=#{$scope.type}&lat=#{$scope.lat}&lng=#{$scope.lng}&rad=#{$scope.rad}"
    webView = new steroids.views.WebView("/views/places/list.html" + params)
    steroids.layers.push
      view: webView
      navigationBar: false


# List: http://localhost/views/places/list.html?type=<type>&lat=<lat>&lng=<lng>
placesApp.controller "ListCtrl", ($scope, PlacesRestangular) ->
  $scope.places = []
  $scope.type = steroids.view.params.placetype
  $scope.lat = steroids.view.params.lat
  $scope.lng = steroids.view.params.lng
  $scope.rad = steroids.view.params.rad  #extract these to angular service?

  $scope.fetchPlaces = ->
    $scope.loading = true
    places = PlacesRestangular.all($scope.type)
    params = {lat: $scope.lat, lng: $scope.lng, rad: $scope.rad}
    places.customGETLIST("near", params).then (data) ->
      localStorage.setItem 'places', JSON.stringify(data)
      $scope.places = data
      $scope.loading = false
  $scope.fetchPlaces()

  # Helper function for opening new webviews
  $scope.open = (id) ->
    webView = new steroids.views.WebView("/views/places/show.html?id=" + id)
    steroids.layers.push
      view: webView
      navigationBar: false

  $scope.showFilter = ->
    filterView = new steroids.views.WebView("/views/places/filter.html")
    steroids.modal.show(filterView)

  $scope.hideFilter = ->
    steroids.modal.hide()
    $scope.fetchPlaces()

  $scope.map = ->
    flip = new steroids.Animation("flipHorizontalFromRight")
    webView = new steroids.views.WebView("/views/places/map.html")
    steroids.layers.push
      view: webView
      navigationBar: false
      animation: flip

  $scope.back = ->
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

  $scope.filter = ->
    navigator.notification.alert 'filter me, yo.'

  $scope.list = ->
    $scope.back()

  $scope.back = ->
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

  $scope.search = ->
    $scope.fetchPlaces()

  $scope.fetchPlaces = ->
    $scope.loading = true
    places = PlacesRestangular.all('places')
    params = {text: $scope.searchText}
    places.customGETLIST("search", params).then (data) ->
      localStorage.setItem 'places', JSON.stringify(data)
      $scope.loading = false
      displayResults()

  displayResults = ->
    webView = new steroids.views.WebView("/views/places/list.html")
    steroids.layers.push
      view: webView
      navigationBar: false