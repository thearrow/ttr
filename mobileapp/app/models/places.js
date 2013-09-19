// The contents of individual model .js files will be concatenated into dist/models.js

(function() {

// Protects views where angular is not loaded from errors
if ( typeof angular == 'undefined' ) {
	return;
};


var module = angular.module('PlacesModel', ['restangular']);

module.factory('PlacesRestangular', function(Restangular) {

  return Restangular.withConfig(function(RestangularConfigurer) {

    //Set to heroku address for now, changes need to be made on heroku to be visible to the app!
    RestangularConfigurer.setBaseUrl('http://ttrestaurants.herokuapp.com');

  });

});


})();
