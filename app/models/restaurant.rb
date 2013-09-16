class Restaurant < Place
  extend Enumerize
  extend ActiveModel::Naming

  #enumeration strings defined in /config/locales/en.yml
  #enumerize :best_for, in: [:derp, :derp_two, :derp_three]

  rails_admin do
    #don't show the type field, used automatically for single-table-inheritance.
    #don't show the food field, because hopefully a restaurant serves food.
    exclude_fields :type, :food
  end

end
