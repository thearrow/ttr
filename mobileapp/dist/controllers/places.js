(function() {
  var placesApp;

  placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents", "google-maps"]);

  placesApp.controller("NearbyCtrl", function($scope) {
    var displayResults, geocodeAddress, onError, onSuccess;
    $scope.type = 'places';
    $scope.lat = 0.0;
    $scope.lng = 0.0;
    $scope.locationText = "";
    $scope.nearbyCurrent = function() {
      return navigator.geolocation.getCurrentPosition(onSuccess, onError);
    };
    onError = function(error) {
      return navigator.notification.alert("Couldn't get your location: " + error.message);
    };
    onSuccess = function(position) {
      $scope.lat = position.coords.latitude;
      $scope.lng = position.coords.longitude;
      return displayResults();
    };
    $scope.nearbyText = function() {
      if ($scope.locationText.length === 0) {
        return navigator.notification.alert("Please enter a location (address/zip/city/etc.)");
      } else {
        return geocodeAddress();
      }
    };
    geocodeAddress = function() {
      var geocoder;
      geocoder = new google.maps.Geocoder();
      return geocoder.geocode({
        address: $scope.locationText
      }, function(results, status) {
        if (status === google.maps.GeocoderStatus.OK) {
          $scope.lat = results[0].geometry.location.lat();
          $scope.lng = results[0].geometry.location.lng();
          return displayResults();
        } else {
          return console.log(status);
        }
      });
    };
    return displayResults = function() {
      var params;
      params = "?type=" + $scope.type + "&lat=" + $scope.lat + "&lng=" + $scope.lng + "&rad=10";
      return steroids.layers.push({
        view: new steroids.views.WebView("/views/places/list.html" + params),
        navigationBar: false
      });
    };
  });

  placesApp.controller("ListCtrl", function($scope, PlacesRestangular) {
    $scope.places = [];
    localStorage.setItem('params', JSON.stringify(steroids.view.params));
    window.addEventListener("message", function(msg) {
      if (msg.data.type === "reload") {
        $scope.order = msg.data.order;
        return $scope.fetchPlaces();
      }
    });
    $scope.fetchPlaces = function() {
      var params, places, search_or_near;
      $scope.loading = true;
      params = JSON.parse(localStorage.getItem('params'));
      places = PlacesRestangular.all(params.type);
      search_or_near = steroids.view.params.text != null ? "search" : "near";
      return places.customGETLIST(search_or_near, params).then(function(data) {
        localStorage.setItem('places', JSON.stringify(data));
        $scope.places = data;
        return $scope.loading = false;
      });
    };
    $scope.fetchPlaces();
    $scope.open = function(id) {
      return steroids.layers.push({
        view: new steroids.views.WebView("/views/places/show.html?id=" + id),
        navigationBar: false
      });
    };
    $scope.showFilter = function() {
      return steroids.layers.push({
        view: new steroids.views.WebView("/views/places/filter.html"),
        navigationBar: false,
        animation: new steroids.Animation('slideFromBottom')
      });
    };
    $scope.map = function() {
      return steroids.layers.push({
        view: new steroids.views.WebView("/views/places/map.html"),
        navigationBar: false,
        animation: new steroids.Animation("flipHorizontalFromRight")
      });
    };
    return $scope.back = function() {
      return steroids.layers.pop();
    };
  });

  placesApp.controller("FilterCtrl", function($scope) {
    var params;
    params = JSON.parse(localStorage.getItem('params'));
    $scope.type = params.type;
    $scope.rad = params.rad;
    $scope.order = params.order || '';
    return $scope.hideFilter = function() {
      var msg;
      params.type = $scope.type;
      params.rad = $scope.rad;
      params.order = $scope.order;
      localStorage.setItem('params', JSON.stringify(params));
      msg = {
        type: 'reload',
        order: $scope.order
      };
      window.postMessage(msg, "*");
      return steroids.layers.pop();
    };
  });

  placesApp.controller("MapCtrl", function($scope) {
    var content, marker, params, _i, _len, _ref;
    $scope.places = JSON.parse(localStorage.getItem('places'));
    params = JSON.parse(localStorage.getItem('params'));
    _ref = $scope.places;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      marker = _ref[_i];
      content = "<h3 style='color: royalblue;' onclick=\"steroids.layers.push(      {view: new steroids.views.WebView('/views/places/show.html?id=" + marker.id + "'),navigationBar: false});\">      " + marker.name + "</h3>";
      marker.infoWindow = content;
    }
    angular.extend($scope, {
      center: {
        latitude: params.lat,
        longitude: params.lng
      },
      markers: $scope.places,
      zoom: 12
    });
    $scope.filter = function() {
      return navigator.notification.alert('filter me, yo.');
    };
    return $scope.back = function() {
      return steroids.layers.pop();
    };
  });

  placesApp.controller("ShowCtrl", function($scope) {
    var place, places;
    places = JSON.parse(localStorage.getItem('places'));
    $scope.place = ((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = places.length; _i < _len; _i++) {
        place = places[_i];
        if (+place.id === +steroids.view.params.id) {
          _results.push(place);
        }
      }
      return _results;
    })())[0];
    return $scope.back = function() {
      return steroids.layers.pop();
    };
  });

  placesApp.controller("SearchCtrl", function($scope) {
    var displayResults;
    $scope.search = function() {
      return displayResults();
    };
    return displayResults = function() {
      var params;
      params = "?type=places&text=" + $scope.searchText + "&rad=10";
      return steroids.layers.push({
        view: new steroids.views.WebView("/views/places/list.html" + params),
        navigationBar: false
      });
    };
  });

}).call(this);
