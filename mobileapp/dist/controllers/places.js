(function() {
  var placesApp;

  placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"]);

  placesApp.controller("NearbyCtrl", function($scope, PlacesRestangular) {
    var displayResults, onError, onSuccess;
    $scope.placeType = 'places';
    $scope.lat = 0.0;
    $scope.lng = 0.0;
    $scope.locationText = "";
    $scope.latSearch = true;
    $scope.searchRadius = 10;
    $scope.nearbyCurrent = function() {
      $scope.loading = true;
      $scope.latSearch = true;
      return navigator.geolocation.getCurrentPosition(onSuccess, onError);
    };
    onError = function(error) {
      return navigator.notification.alert("Couldn't get your location: " + error.message);
    };
    onSuccess = function(position) {
      $scope.lat = position.coords.latitude;
      $scope.lng = position.coords.longitude;
      return $scope.fetchPlaces();
    };
    $scope.nearbyText = function() {
      $scope.loading = true;
      $scope.latSearch = false;
      if ($scope.locationText.length === 0) {
        return navigator.notification.alert("Please enter a location (address/zip/city/etc.)");
      } else {
        return $scope.fetchPlaces();
      }
    };
    $scope.fetchPlaces = function() {
      var params, places;
      places = PlacesRestangular.all($scope.placeType);
      if ($scope.latSearch) {
        params = {
          lat: $scope.lat,
          lng: $scope.lng,
          rad: $scope.searchRadius
        };
      } else {
        params = {
          text: $scope.locationText,
          rad: $scope.searchRadius
        };
      }
      return places.customGETLIST("near", params).then(function(data) {
        localStorage.setItem('places', JSON.stringify(data));
        return displayResults();
      });
    };
    return displayResults = function() {
      var webView;
      $scope.loading = false;
      webView = new steroids.views.WebView("/views/places/list.html");
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
  });

  placesApp.controller("ListCtrl", function($scope) {
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
