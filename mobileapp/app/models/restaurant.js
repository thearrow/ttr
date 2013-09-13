// The contents of individual model .js files will be concatenated into dist/models.js

(function() {

// Protects views where angular is not loaded from errors
if ( typeof angular == 'undefined' ) {
	return;
}


var module = angular.module('RestaurantModel', ['restangular']);

module.factory('RestaurantRestangular', function(Restangular) {

  return Restangular.withConfig(function(RestangularConfigurer) {

    //Set to local machine's ip for dev, heroku address for staging
    RestangularConfigurer.setBaseUrl('http://192.168.0.14:3000');

//    RestangularConfigurer.setDefaultHeaders({
//      'Accept': 'application/vnd.stackmob+json; version=0',
//      'X-StackMob-API-Key-<YOUR-API-KEY-HERE>': '1'
//    });

  });

});


})();
