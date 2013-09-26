(function() {
  var placesApp;

  placesApp = angular.module("placesApp", ["PlacesModel", "hmTouchevents"]);

  placesApp.controller("NearbyCtrl", function($scope, PlacesRestangular) {
    $scope.placeType = 'places';
    $scope.nearbyCurrent = function() {
      var webView;
      webView = new steroids.views.WebView("/views/places/list.html?placeType=" + $scope.placeType);
      return steroids.layers.push({
        view: webView,
        navigationBar: false
      });
    };
    return $scope.nearbyZip = function() {
      return alert("ZIP!");
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
      $scope.loading = true;
      return places.getList().then(function(data) {
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
      steroids.layers.pop();
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
