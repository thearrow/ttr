var restaurantApp = angular.module('restaurantApp', ['RestaurantModel', 'hmTouchevents']);


// Index: http://localhost/views/restaurant/index.html

restaurantApp.controller('IndexCtrl', function ($scope, RestaurantRestangular) {

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
  steroids.view.navigationBar.show("Restaurants");

  // ..and add a button to it
  var addButton = new steroids.buttons.NavigationBarButton();
  addButton.title = "Add";

  // ..set callback for tap action
  addButton.onTap = function() {
    var addView = new steroids.views.WebView("/views/restaurant/new.html");
    steroids.modal.show(addView);
  };

  // and finally put it to navigation bar
  steroids.view.navigationBar.setButtons({
    right: [addButton]
  });


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


// New: http://localhost/views/restaurant/new.html

restaurantApp.controller('NewCtrl', function ($scope, RestaurantRestangular) {

  $scope.close = function() {
    steroids.modal.hide();
  };

  $scope.create = function(restaurant) {
    $scope.loading = true;

    RestaurantRestangular.all('restaurant').post(restaurant).then(function() {

      // Notify the index.html to reload
      var msg = { status: 'reload' };
      window.postMessage(msg, "*");

      $scope.close();
      $scope.loading = false;

    }, function() {
      $scope.loading = false;

      alert("Error when creating the object, is Restangular configured correctly, are the permissions set correctly?");

    });

  }

  $scope.restaurant = {};

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