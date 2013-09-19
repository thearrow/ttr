var placesApp = angular.module('placesApp', ['PlacesModel', 'hmTouchevents']);

// Nearby: http://localhost/views/places/nearby.html
placesApp.controller('NearbyCtrl', function ($scope, PlacesRestangular) {
    $scope.nearbyCurrent = function(){
        webView = new steroids.views.WebView("/views/places/list.html");
        steroids.layers.push({
            view: webView,
            navigationBar: false
        });
    };

    $scope.nearbyZip = function(){
        alert('ZIP!');
    };
});

// List: http://localhost/views/places/list.html
placesApp.controller('ListCtrl', function ($scope, PlacesRestangular) {
    // This will be populated with Restangular
    $scope.places = [];

    // Helper function for opening new webviews
    $scope.open = function (id) {
        webView = new steroids.views.WebView("/views/places/show.html?id=" + id);
        steroids.layers.push({
            view: webView,
            navigationBar: false
        });
    };

    // Helper function for loading places data with spinner
    $scope.loadPlaces = function () {
        $scope.loading = true;

        places.getList().then(function (data) {
            $scope.places = data;
            $scope.loading = false;
        });
    };

    // Fetch all objects from the backend (see app/models/places.js)
    var places = PlacesRestangular.all('places');
    $scope.loadPlaces();

    // Get notified when an another webview modifies the data and reload
    window.addEventListener("message", function (event) {
        // reload data on message with reload status
        if (event.data.status === "reload") {
            $scope.loadPlaces();
        }
    });

    $scope.goToMap = function () {
        var flip = new steroids.Animation("flipHorizontalFromRight");
        webView = new steroids.views.WebView("/views/places/map.html");
        steroids.layers.push({
            view: webView,
            navigationBar: false,
            animation: flip
        });
    };

    $scope.goBack = function(){
        steroids.layers.pop();
    };
});

// Map: http://localhost/views/places/map.html
placesApp.controller('MapCtrl', function ($scope, PlacesRestangular) {
    // This will be populated with Restangular
    $scope.places = [];

    // Helper function for opening new webviews
    $scope.open = function (id) {
        webView = new steroids.views.WebView("/views/places/show.html?id=" + id);
        steroids.layers.push({
            view: webView,
            navigationBar: false
        });
    };

    // Helper function for loading places data with spinner
    $scope.loadPlaces = function () {
        $scope.loading = true;

        places.getList().then(function (data) {
            $scope.places = data;
            $scope.loading = false;
        });

    };

    // Fetch all objects from the backend (see app/models/places.js)
    var places = PlacesRestangular.all('places');
    $scope.loadPlaces();


    // Get notified when an another webview modifies the data and reload
    window.addEventListener("message", function (event) {
        // reload data on message with reload status
        if (event.data.status === "reload") {
            $scope.loadPlaces();
        }
    });

    $scope.goToList = function () {
        steroids.layers.pop();
    };

    $scope.goBack = function(){
        steroids.layers.pop();
        steroids.layers.pop();
    };
});


// Show: http://localhost/views/places/show.html?id=<id>
placesApp.controller('ShowCtrl', function ($scope, PlacesRestangular) {
    // Helper function for loading places data with spinner
    $scope.loadPlaces = function () {
        $scope.loading = true;

        place.get().then(function (data) {
            $scope.place = data;
            $scope.loading = false;
        });

    };

    // Save current places id to localStorage (edit.html gets it from there)
    localStorage.setItem("currentPlacesId", steroids.view.params.id);

    var place = PlacesRestangular.one("places", steroids.view.params.id);
    $scope.loadPlaces()

    // When the data is modified in the edit.html, get notified and update (edit is on top of this view)
    window.addEventListener("message", function (event) {
        if (event.data.status === "reload") {
            $scope.loadPlaces()
        }
    });


    $scope.goBack = function () {
        steroids.layers.pop();
    };
});


// Search: http://localhost/views/places/search.html
placesApp.controller('SearchCtrl', function ($scope, PlacesRestangular) {

});