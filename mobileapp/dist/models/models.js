(function() {
  (function() {
    var module;
    if (typeof angular === "undefined") {
      return;
    }
    module = angular.module("PlacesModel", ["restangular"]);
    return module.factory("PlacesRestangular", function(Restangular) {
      return Restangular.withConfig(function(RestangularConfigurer) {
        return RestangularConfigurer.setBaseUrl("http://ttrestaurants.herokuapp.com");
      });
    });
  })();

}).call(this);
