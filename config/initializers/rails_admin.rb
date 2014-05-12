RailsAdmin.config do |config|

  config.authorize_with :cancan

  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.included_models = ["Book", "User", "Copy"]

  config.model 'Copy' do
    object_label_method :index

    list do
      field :id
      field :index
      field :book
      field :publication
      field :missing
      exclude_fields :state
    end

    edit do
      field :book
      field :index
      field :publication
      field :missing
      exclude_fields :state
    end
  end

  config.model 'Book' do
    list do
      field :id
      field :title
      field :author
      field :details
      field :created_at do
        strftime_format "%d.%m.%Y %H:%M"
      end
      field :updated_at do
        strftime_format "%d.%m.%Y %H:%M"
      end
    end

    edit do
      field :title
      field :author
      field :details
      field :copies
    end

    show do
      field :id
      field :title
      field :author
      field :created_at do
        strftime_format "%d.%m.%Y %H:%M"
      end
      field :updated_at do
        strftime_format "%d.%m.%Y %H:%M"
      end
      field :copies
    end
  end

  config.model 'User' do
    list do
      field :id
      field :name
      field :email
      field :phone
      field :admin
    end

    edit do
      group :default do
        field :name
        field :email
        field :phone
      end
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except 'User'
    end
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
