(function() {
  var placesApp;

  placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"]);

  placesApp.controller("NearbyCtrl", function($scope, PlacesRestangular) {
    var displayResults, onError, onSuccess;
    $scope.placeType = 'places';
    $scope.lat = 0.0;
    $scope.lng = 0.0;
    onError = function(error) {
      return alert("Couldn't get your location: " + error.message);
    };
    onSuccess = function(position) {
      $scope.lat = position.coords.latitude;
      $scope.lng = position.coords.longitude;
      return displayResults();
    };
    $scope.nearbyCurrent = function() {
      return navigator.geolocation.getCurrentPosition(onSuccess, onError);
    };
    $scope.nearbyZip = function() {
      return alert("ZIP!");
    };
    return displayResults = function() {
      var webView;
      webView = new steroids.views.WebView("/views/places/list.html?placeType=" + $scope.placeType + "&lat=" + $scope.lat + "&lng=" + $scope.lng);
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
  });

  placesApp.controller("ListCtrl", function($scope, PlacesRestangular) {
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
      var params;
      $scope.loading = true;
      params = steroids.view.params;
      return places.customGETLIST("near", {
        lat: params.lat,
        lng: params.lng,
        rad: 10
      }).then(function(data) {
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
