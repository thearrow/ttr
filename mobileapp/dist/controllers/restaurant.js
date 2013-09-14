var restaurantApp = angular.module('restaurantApp', ['RestaurantModel', 'hmTouchevents']);

// Nearby List: http://localhost/views/restaurant/nearby_list.html
restaurantApp.controller('NearbyListCtrl', function ($scope, RestaurantRestangular) {

  // This will be populated with Restangular
  $scope.restaurants = [];

  // Helper function for opening new webviews
  $scope.open = function(id) {
    webView = new steroids.views.WebView("/views/restaurant/show.html?id="+id);
    steroids.layers.push(webView);
  };

  // Helper function for loading restaurant data with spinner
  $scope.loadRestaurants = function() {
    $scope.loading = true;

    restaurants.getList().then(function(data) {
      $scope.restaurants = data;
      $scope.loading = false;
    });

  };

  // Fetch all objects from the backend (see app/models/restaurant.js)
  var restaurants = RestaurantRestangular.all('restaurant');
  $scope.loadRestaurants();


  // Get notified when an another webview modifies the data and reload
  window.addEventListener("message", function(event) {
    // reload data on message with reload status
    if (event.data.status === "reload") {
      $scope.loadRestaurants();
    };
  });

  // -- Native navigation
  // Set navigation bar..
  steroids.view.navigationBar.show("List");

  // ..and add a button to it
  var mapButton = new steroids.buttons.NavigationBarButton();
  mapButton.title = "Map";

  // ..set callback for tap action
  mapButton.onTap = function() {
    var mapView = new steroids.views.WebView("/views/restaurant/nearby_map.html");
      steroids.layers.push(mapView);
  };

  // and finally put it to navigation bar
  steroids.view.navigationBar.setButtons({
    right: [mapButton]
  });

});


// Nearby Map: http://localhost/views/restaurant/nearby_map.html
restaurantApp.controller('NearbyMapCtrl', function ($scope, RestaurantRestangular) {

    // -- Native navigation
    // Set navigation bar..
    steroids.view.navigationBar.show("Map");

    var onSuccess = function(position) {
        alert('Latitude: '          + position.coords.latitude          + '\n' +
            'Longitude: '         + position.coords.longitude         + '\n' +
            'Altitude: '          + position.coords.altitude          + '\n' +
            'Accuracy: '          + position.coords.accuracy          + '\n' +
            'Altitude Accuracy: ' + position.coords.altitudeAccuracy  + '\n' +
            'Heading: '           + position.coords.heading           + '\n' +
            'Speed: '             + position.coords.speed             + '\n' +
            'Timestamp: '         + position.timestamp                + '\n');
    };

    function onError(error) {
        alert('code: '    + error.code    + '\n' +
            'message: ' + error.message + '\n');
    }

    navigator.geolocation.getCurrentPosition(onSuccess, onError);

});


// Search: http://localhost/views/restaurant/search.html
restaurantApp.controller('SearchCtrl', function ($scope, RestaurantRestangular) {

    // -- Native navigation
    // Set navigation bar..
    steroids.view.navigationBar.show("Search");

});


// Show: http://localhost/views/restaurant/show.html?id=<id>
restaurantApp.controller('ShowCtrl', function ($scope, RestaurantRestangular) {

  // Helper function for loading restaurant data with spinner
  $scope.loadRestaurant = function() {
    $scope.loading = true;

     restaurant.get().then(function(data) {
       $scope.restaurant = data;
       $scope.loading = false;
       steroids.view.navigationBar.show($scope.restaurant.name);
    });

  };

  // Save current restaurant id to localStorage (edit.html gets it from there)
  localStorage.setItem("currentRestaurantId", steroids.view.params.id);

  var restaurant = RestaurantRestangular.one("restaurant", steroids.view.params.id);
  $scope.loadRestaurant();

  // When the data is modified in the edit.html, get notified and update (edit is on top of this view)
  window.addEventListener("message", function(event) {
    if (event.data.status === "reload") {
      $scope.loadRestaurant()
    };
  });

  // -- Native navigation
  var editButton = new steroids.buttons.NavigationBarButton();
  editButton.title = "Edit";

  editButton.onTap = function() {
    webView = new steroids.views.WebView("/views/restaurant/edit.html");
    steroids.modal.show(webView);
  }

  steroids.view.navigationBar.setButtons({
    right: [editButton]
  });


});


// Edit: http://localhost/views/restaurant/edit.html
restaurantApp.controller('EditCtrl', function ($scope, RestaurantRestangular) {

  var id  = localStorage.getItem("currentRestaurantId"),
      restaurant = RestaurantRestangular.one("restaurant", id);

  $scope.close = function() {
    steroids.modal.hide();
  };

  $scope.update = function(restaurant) {
    $scope.loading = true;

    restaurant.put().then(function() {

      // Notify the show.html to reload data
      var msg = { status: "reload" };
      window.postMessage(msg, "*");

      $scope.close();
      $scope.loading = false;
    }, function() {
      $scope.loading = false;

      alert("Error when editing the object, is Restangular configured correctly, are the permissions set correctly?");
    });

  };

  // Helper function for loading restaurant data with spinner
  $scope.loadRestaurant = function() {
    $scope.loading = true;

    // Fetch a single object from the backend (see app/models/restaurant.js)
    restaurant.get().then(function(data) {
      $scope.restaurant = data;
      $scope.loading = false;
    });
  };

  $scope.loadRestaurant();

});