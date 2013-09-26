# The contents of individual model .coffee files will be concatenated into dist/models.js
(->

  # Protects views where angular is not loaded from errors
  return  if typeof angular is "undefined"
  module = angular.module("PlacesModel", ["restangular"])
  module.factory "PlacesRestangular", (Restangular) ->
    Restangular.withConfig (RestangularConfigurer) ->
      # Set to heroku address for now, changes need to be made on heroku to be visible to the app!
      RestangularConfigurer.setBaseUrl "http://ttrestaurants.herokuapp.com"

)()