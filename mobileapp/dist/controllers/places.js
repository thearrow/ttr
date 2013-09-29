(function() {
  var placesApp;

  placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"]);

  placesApp.controller("NearbyCtrl", function($scope) {
    var displayResults, onError, onSuccess;
    $scope.placeType = 'places';
    $scope.lat = 0.0;
    $scope.lng = 0.0;
    $scope.locationText = "";
    $scope.latSearch = true;
    onError = function(error) {
      return navigator.notification.alert("Couldn't get your location: " + error.message);
    };
    onSuccess = function(position) {
      $scope.lat = position.coords.latitude;
      $scope.lng = position.coords.longitude;
      return displayResults();
    };
    $scope.nearbyCurrent = function() {
      $scope.latSearch = true;
      return navigator.geolocation.getCurrentPosition(onSuccess, onError);
    };
    $scope.nearbyText = function() {
      $scope.latSearch = false;
      if ($scope.locationText.length === 0) {
        return navigator.notification.alert("Please enter a location (address/zip/city/etc.)");
      } else {
        return displayResults();
      }
    };
    return displayResults = function() {
      var params, webView;
      if ($scope.latSearch) {
        params = "lat=" + $scope.lat + "&lng=" + $scope.lng;
      } else {
        params = "loctext=" + (encodeURIComponent($scope.locationText));
      }
      webView = new steroids.views.WebView("/views/places/list.html?placeType=" + $scope.placeType + "&" + params);
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
  });

  placesApp.controller("ListCtrl", function($scope, PlacesRestangular) {
    var places;
    $scope.searchRadius = 10;
    $scope.places = [];
    $scope.open = function(id) {
      var webView;
      webView = new steroids.views.WebView("/views/places/show.html?id=" + id);
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
    $scope.loadPlaces = function() {
      var params;
      $scope.loading = true;
      if (steroids.view.params.lat) {
        params = {
          lat: steroids.view.params.lat,
          lng: steroids.view.params.lng,
          rad: $scope.searchRadius
        };
      } else {
        params = {
          text: decodeURIComponent(steroids.view.params.loctext),
          rad: $scope.searchRadius
        };
      }
      return places.customGETLIST("near", params).then(function(data) {
        $scope.places = data;
        return $scope.loading = false;
      });
    };
    places = PlacesRestangular.all(steroids.view.params.placeType);
    $scope.loadPlaces();
    window.addEventListener("message", function(event) {
      if (event.data.status === "reload") {
        return $scope.loadPlaces();
      }
    });
    $scope.goToMap = function() {
      var flip, webView;
      flip = new steroids.Animation("flipHorizontalFromRight");
      webView = new steroids.views.WebView("/views/places/map.html");
      return steroids.layers.push({
        view: webView,
        navigationBar: false,
        animation: flip
      });
    };
    return $scope.goBack = function() {
      return steroids.layers.pop();
    };
  });

  placesApp.controller("MapCtrl", function($scope, PlacesRestangular) {
    var places;
    $scope.places = [];
    $scope.open = function(id) {
      var webView;
      webView = new steroids.views.WebView("/views/places/show.html?id=" + id);
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
    $scope.loadPlaces = function() {
      $scope.loading = true;
      return places.getList().then(function(data) {
        $scope.places = data;
        return $scope.loading = false;
      });
    };
    places = PlacesRestangular.all("places");
    $scope.loadPlaces();
    window.addEventListener("message", function(event) {
      if (event.data.status === "reload") {
        return $scope.loadPlaces();
      }
    });
    $scope.goToList = function() {
      return steroids.layers.pop();
    };
    return $scope.goBack = function() {
      return steroids.layers.pop();
    };
  });

  placesApp.controller("ShowCtrl", function($scope, PlacesRestangular) {
    var place;
    $scope.loadPlaces = function() {
      $scope.loading = true;
      return place.get().then(function(data) {
        $scope.place = data;
        return $scope.loading = false;
      });
    };
    localStorage.setItem("currentPlacesId", steroids.view.params.id);
    place = PlacesRestangular.one("places", steroids.view.params.id);
    $scope.loadPlaces();
    window.addEventListener("message", function(event) {
      if (event.data.status === "reload") {
        return $scope.loadPlaces();
      }
    });
    return $scope.goBack = function() {
      return steroids.layers.pop();
    };
  });

  placesApp.controller("SearchCtrl", function($scope, PlacesRestangular) {});

}).call(this);
