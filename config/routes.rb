Librarian::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: "users/registrations" }

  resource :profile

  get '/profile/reservations' => 'profiles#reservations', as: :profile_reservations
  get '/profile/orders' => 'profiles#orders', as: :profile_orders
  delete 'porfile/reservations/:id' => 'profiles#destroy_reservation', as: :profile_reservation

  resources :books, only: [:index] do
    member do
      put :reserve
      get :reserve
    end
    resources :reservations, :only => [:create, :index]
  end

  resources :reservations, :only => [:destroy]

  resources :users, :only => :index do
    member do
      get :autocomplete
    end
  end

  resources :copies, :only => [:show, :destroy] do
    member do
      patch :check_in
      get :borrowed
      get :available
      post :check_out
    end
  end

  root to: "home#index"
end
