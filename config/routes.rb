Librarian::Application.routes.draw do

  devise_for :users, controllers: { registrations: "users/registrations" }

  resource :home, :only => :index
  resources :books, only: [:index] do
    member do
      put :reserve
      get :reserve
    end
    resources :copies, :only => [:new, :edit, :create, :update]
    resources :reservations, :only => [:create, :index]
  end

  resources :users, :only => :index do
    member do
      get :autocomplete
    end
  end

  resources :copies, :only => [:show, :destroy] do
    member do
      patch :check_in
    end
    collection do
      post :check_out
    end
  end

  root to: "home#index"
end
