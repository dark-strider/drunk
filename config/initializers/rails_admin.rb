# encoding: utf-8
RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  # If you want to track changes on your models:
  # config.audit_with :history, User

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, User

  config.authenticate_with { authenticate_user! }
  config.authorize_with :cancan
  config.current_user_method { current_user } # auto-generated
  # Админ.панель предоставляет права из всех ролей которые есть у пользователя.
  # Но редактировать можно только те поля, которые напрямую уканы 
  # в attr_accessible для первой в списке роли. Поэтому
  # важно указывать первой роль с наибольшими правами доступа к attr_accessible.
  config.attr_accessible_role { _current_user.role.to_sym }

  # config.models do
  #   edit do
  #     fields do
  #       visible do
  #         visible && !read_only
  #       end
  #     end
  #   end
  # end

  config.actions do
    # Root actions:
    dashboard
    # Collection actions:
    index
    new
    export
    #history_index
    bulk_delete
    # Member actions:
    show
    edit
    delete
    #history_show
    show_in_app
  end

  config.main_app_name = ['', 'drunk dashboard']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }
  # config.total_columns_width = 50

  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [City, Country, Place, Service, User]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [City, Country, Place, Service, User]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  # config.model User do
  #   # Found associations:
  #     configure :services, :has_many_association
  #     # Found columns:
  #     # configure :_type, :text  # hidden 
  #     configure :_id, :bson_object_id
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :role, :string
  #     configure :email, :text
  #     configure :password, :password  # hidden 
  #     configure :password_confirmation, :password  # hidden 
  #     # configure :reset_password_token, :text  # hidden 
  #     configure :reset_password_sent_at, :datetime
  #     configure :remember_created_at, :datetime
  #     configure :sign_in_count, :integer
  # 
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end

  config.model User do
    configure :gender, :enum do
      enum do
        User::GENDERS
      end
    end
    configure :role, :enum do
      enum do
        User::ROLES
      end
    end
    configure :current_sign_in_ip, :string
    configure :last_sign_in_ip, :string
  end

  config.model Service do
    configure :provider, :string
    configure :uid, :string
  end

  config.model Place do
    configure :captain, :enum do
      enum do
        User.all.map{ |u| [u.name, u.id] }
      end
    end
    configure :status, :enum do
      enum do
        Place::STATUS
      end
    end
  end

  config.model Location do
    configure :country, :enum do
      enum do
        Country.all.map(&:name)
      end
    end
    configure :city, :enum do
      enum do
        City.all.map(&:name)
      end
    end
  end

  config.model Event do
    configure :condition, :enum do
      enum do
        Event::CONDITION.map{ |k,v| [v,k] }
      end
    end
    configure :visibility, :enum do
      enum do
        Event::VISIBILITY.map{ |k,v| [v,k] }
      end
    end
    configure :joinable, :enum do
      enum do
        Event::JOINABLE.map{ |k,v| [v,k] }
      end
    end
    configure :inviteable, :enum do
      enum do
        Event::INVITEABLE.map{ |k,v| [v,k] }
      end
    end
  end

  config.model Friend do
    configure :friend_id, :enum do
      enum do
        User.all.map{ |u| [u.name, u.id] }
      end
    end
  end
end
