# This file is written in coffeescript - a leaner javascript - indentation matters.
# See: http://coffeescript.org/

placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents", "google-maps"])

#bootstrap angular app
document.addEventListener "deviceready", ->
  angular.bootstrap document, ['placesApp']

# Nearby: http://localhost/views/places/nearby.html
placesApp.controller "NearbyCtrl", ($scope) ->
  #push notification handling
  document.addEventListener "deviceready", (->
    push = window.pushNotification
    push.enablePush()
    push.getPushID()
    # Incoming messages (user swipes on the push notification from outside the app)
    push.getIncoming (incoming) ->
      if incoming.message
        navigator.notification.alert incoming.message
    # User has the app open when a push is sent
    push.registerEvent "push", (data) ->
      navigator.notification.alert data.message
    # Registration
    push.registerEvent "registration", (error, id) ->
      if error
        navigator.notification.alert error
    document.addEventListener "resume", (->
      window.pushNotification.resetBadge()
    ), false
    push.registerForNotificationTypes(push.notificationType.badge | push.notificationType.sound | push.notificationType.alert)
  ), false

  $scope.type = 'places'
  $scope.lat = 0.0
  $scope.lng = 0.0
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
    params = "?type=#{$scope.type}&lat=#{$scope.lat}&lng=#{$scope.lng}&rad=10"
    steroids.layers.push
      view: new steroids.views.WebView("/views/places/list.html" + params)
      navigationBar: false



# List: http://localhost/views/places/list.html?type=<type>&lat=<lat>&lng=<lng>&rad=<rad>
placesApp.controller "ListCtrl", ($scope, PlacesRestangular) ->
  $scope.places = []
  localStorage.setItem 'params', JSON.stringify(steroids.view.params)

  window.addEventListener "message", (msg)->
    if msg.data.type is "reload"
      #filter has been changed, refresh places
      $scope.order = msg.data.order
      $scope.fetchPlaces()

  $scope.fetchPlaces = ->
    $scope.loading = true
    params = JSON.parse localStorage.getItem('params')
    places = PlacesRestangular.all(params.type)
    search_or_near = if steroids.view.params.text? then "search" else "near"
    places.customGETLIST(search_or_near, params).then (data) ->
      localStorage.setItem 'places', JSON.stringify(data)
      $scope.places = data
      $scope.loading = false
  $scope.fetchPlaces()

  # Helper function for opening new webviews
  $scope.open = (id) ->
    steroids.layers.push
      view: new steroids.views.WebView("/views/places/show.html?id=" + id)
      navigationBar: false

  $scope.showFilter = ->
    steroids.layers.push
      view: new steroids.views.WebView("/views/places/filter.html")
      navigationBar: false
      animation: new steroids.Animation 'slideFromBottom'

  $scope.map = ->
    steroids.layers.push
      view: new steroids.views.WebView("/views/places/map.html")
      navigationBar: false
      animation: new steroids.Animation("flipHorizontalFromRight")

  $scope.back = ->
    steroids.layers.pop()



# Filter: http://localhost/views/places/list.html?type=<type>&lat=<lat>&lng=<lng>&rad=<rad>
placesApp.controller "FilterCtrl", ($scope) ->
  params = JSON.parse localStorage.getItem('params')
  $scope.type = params.type
  $scope.rad = params.rad
  $scope.order = params.order || ''

  $scope.hideFilter = ->
    params.type = $scope.type
    params.rad = $scope.rad
    params.order = $scope.order
    localStorage.setItem 'params', JSON.stringify(params)
    msg = type: 'reload', order: $scope.order
    window.postMessage(msg, "*")
    steroids.layers.pop()



# Map: http://localhost/views/places/map.html
placesApp.controller "MapCtrl", ($scope) ->
  # These are populated by ListCtrl
  $scope.places = JSON.parse localStorage.getItem('places')
  params = JSON.parse localStorage.getItem('params')

  for marker in $scope.places
    content = "<h3 style='color: #A8253B;' onclick=\"steroids.layers.push(
      {view: new steroids.views.WebView('/views/places/show.html?id=#{marker.id}'),navigationBar: false});\">
      #{marker.name}</h3>"
    marker.infoWindow = content

  angular.extend $scope,
    center:
      latitude: params.lat # initial map center latitude
      longitude: params.lng # initial map center longitude
    markers: $scope.places # an array of markers,
    zoom: 12 # the zoom level

  $scope.filter = ->
    navigator.notification.alert 'filter me, yo.'

  $scope.back = ->
    steroids.layers.pop()



# Show: http://localhost/views/places/show.html?id=<id>
placesApp.controller "ShowCtrl", ($scope) ->
  places = JSON.parse localStorage.getItem('places')

  # +'s for conversion to int, [0] takes first (only) result of comprehension
  $scope.place = (place for place in places when +place.id is +steroids.view.params.id)[0]
  $scope.formatted_price = Array(+$scope.place.price+1).join '$'
  $scope.best_tags = 'Best For: ' + (x.name for x in $scope.place.tag_best_fors).join ', '
  $scope.atmosphere_tags = 'Atmosphere: ' + (x.name for x in $scope.place.tag_atmospheres).join ', '

  $scope.back = ->
    steroids.layers.pop()



# Search: http://localhost/views/places/search.html
placesApp.controller "SearchCtrl", ($scope) ->
  $scope.search = ->
    displayResults()

  displayResults = ->
    params = "?type=places&text=#{$scope.searchText}&rad=10"
    steroids.layers.push
      view: new steroids.views.WebView("/views/places/list.html" + params)
      navigationBar: false