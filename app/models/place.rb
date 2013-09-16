class Place < ActiveRecord::Base

  rails_admin do
    #don't show the type field, used automatically for single-table-inheritance
    exclude_fields :type
  end

end
