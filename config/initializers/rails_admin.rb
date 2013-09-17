# RailsAdmin config file. Generated on September 16, 2013 18:25
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Tasting Table Restaurants', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_admin } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, 'Admin'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'Admin'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]

  config.navigation_static_links = {
      'Push Notifications' => '/push_notifications'
  }

  config.model 'Admin' do
    navigation_icon 'icon-user'
  end

  #Display labels defined in /config/locales/en.yml
  config.model 'Place' do
    navigation_icon 'icon-home'
    exclude_fields :type

    configure :food do
      label 'Serves Food?'
    end
    configure :reservations do
      label 'Reservations Accepted?'
    end
    configure :outdoor do
      label 'Outdoor Area?'
    end
  end

  config.model 'Bar' do
    navigation_icon 'icon-glass'
    exclude_fields :type

    configure :food do
      label 'Serves Food?'
    end
    configure :reservations do
      label 'Reservations Accepted?'
    end
    configure :outdoor do
      label 'Outdoor Area?'
    end
  end

  config.model 'Restaurant' do
    navigation_icon 'icon-home'
    exclude_fields :type, :food

    configure :reservations do
      label 'Reservations Accepted?'
    end
    configure :outdoor do
      label 'Outdoor Area?'
    end
  end

  config.model 'TagAtmosphere' do
    navigation_icon 'icon-tags'
  end
  config.model 'TagBestFor' do
    navigation_icon 'icon-tags'
  end

end
