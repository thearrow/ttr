(function() {
  var placesApp;

  placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"]);

  placesApp.controller("NearbyCtrl", function($scope) {
    var displayResults, geocodeAddress, onError, onSuccess;
    $scope.type = 'places';
    $scope.lat = 0.0;
    $scope.lng = 0.0;
    $scope.rad = 10;
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
      var params, webView;
      params = "?placetype=" + $scope.type + "&lat=" + $scope.lat + "&lng=" + $scope.lng + "&rad=" + $scope.rad;
      webView = new steroids.views.WebView("/views/places/list.html" + params);
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
  });

  placesApp.controller("ListCtrl", function($scope, PlacesRestangular) {
    $scope.places = [];
    $scope.type = steroids.view.params.placetype;
    $scope.lat = steroids.view.params.lat;
    $scope.lng = steroids.view.params.lng;
    $scope.rad = steroids.view.params.rad;
    $scope.fetchPlaces = function() {
      var params, places;
      $scope.loading = true;
      places = PlacesRestangular.all($scope.type);
      params = {
        lat: $scope.lat,
        lng: $scope.lng,
        rad: $scope.rad
      };
      return places.customGETLIST("near", params).then(function(data) {
        localStorage.setItem('places', JSON.stringify(data));
        $scope.places = data;
        return $scope.loading = false;
      });
    };
    $scope.fetchPlaces();
    $scope.open = function(id) {
      var webView;
      webView = new steroids.views.WebView("/views/places/show.html?id=" + id);
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
    $scope.showFilter = function() {
      var filterView;
      filterView = new steroids.views.WebView("/views/places/filter.html");
      return steroids.modal.show(filterView);
    };
    $scope.hideFilter = function() {
      steroids.modal.hide();
      return $scope.fetchPlaces();
    };
    $scope.map = function() {
      var flip, webView;
      flip = new steroids.Animation("flipHorizontalFromRight");
      webView = new steroids.views.WebView("/views/places/map.html");
      return steroids.layers.push({
        view: webView,
        navigationBar: false,
        animation: flip
      });
    };
    return $scope.back = function() {
      return steroids.layers.pop();
    };
  });

  placesApp.controller("MapCtrl", function($scope) {
    $scope.places = JSON.parse(localStorage.getItem('places'));
    $scope.open = function(id) {
      var webView;
      webView = new steroids.views.WebView("/views/places/show.html?id=" + id);
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
    $scope.filter = function() {
      return navigator.notification.alert('filter me, yo.');
    };
    $scope.list = function() {
      return $scope.back();
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
    return $scope.goBack = function() {
      return steroids.layers.pop();
    };
  });

  placesApp.controller("SearchCtrl", function($scope, PlacesRestangular) {
    var displayResults;
    $scope.search = function() {
      return $scope.fetchPlaces();
    };
    $scope.fetchPlaces = function() {
      var params, places;
      $scope.loading = true;
      places = PlacesRestangular.all('places');
      params = {
        text: $scope.searchText
      };
      return places.customGETLIST("search", params).then(function(data) {
        localStorage.setItem('places', JSON.stringify(data));
        $scope.loading = false;
        return displayResults();
      });
    };
    return displayResults = function() {
      var webView;
      webView = new steroids.views.WebView("/views/places/list.html");
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
  });

}).call(this);
