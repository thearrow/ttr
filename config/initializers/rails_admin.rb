# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|
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
      'Push Notifications' => '/push'
  }

  config.model 'DeviceToken' do
    visible false
  end

  config.model 'Admin' do
    navigation_icon 'icon-user'
  end

  config.model 'Place' do
    navigation_icon 'icon-home'
    exclude_fields :type
    configure_fields()
  end

  config.model 'Bar' do
    navigation_icon 'icon-glass'
    exclude_fields :type
    configure_fields()
  end

  config.model 'Restaurant' do
    navigation_icon 'icon-home'
    exclude_fields :type, :food
    configure_fields()
  end

  config.model 'TagAtmosphere' do
    navigation_icon 'icon-tags'
  end
  config.model 'TagBestFor' do
    navigation_icon 'icon-tags'
  end

  #Category display labels (Tags - Atmosphere, etc.) are defined in /config/locales/en.yml

  def configure_fields
    edit do
      group :default do
        label 'General Info'
      end
      group :attrib do
        label 'Attributes'
      end
      group :tags do
        label 'Tags'
        help 'Choose from tags on the left-list, then add them to the right-list.'
      end
      group :latlng do
        label 'Latitude & Longitude'
        help 'If left blank, latitude & longitude will be automatically created from address information.'
      end
    end

    #add lat & lng fields to latlng group
    configure :latitude do
      group :latlng
    end
    configure :longitude do
      group :latlng
    end

    #add tag fields to tags group
    configure :tag_atmospheres do
      label 'Atmosphere'
      group :tags
    end
    configure :tag_best_fors do
      label 'Best For'
      group :tags
    end

    #add other fields to attrib group
    configure :reservations do
      label 'Reservations Accepted?'
      group :attrib
    end
    configure :reservations_link do
      label 'Reservations Link'
      help ''
      group :attrib
    end
    configure :food do
      label 'Serves Food?'
      group :attrib
    end
    configure :outdoor do
      label 'Outdoor Area?'
      group :attrib
    end
    configure :price do
      help 'Think: 1=$, 2=$$, 3=$$$, 4=$$$$'
      group :attrib
    end
    configure :tt_article do
      label 'Tasting Table Article Link'
      help ''
      group :attrib
    end
    configure :tt_date do
      label 'Tasting Table Review Date'
      help ''
      group :attrib
    end

  end
end
