Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create, :destroy]
      resources :users
      resources :properties
    end
  end

  namespace :admin do
    get 'log_in' => 'sessions#new', as: :log_in
    post 'log_in' => 'sessions#create'
    match 'log_out' => 'sessions#destroy', as: :log_out, via: [:get, :post]
    root to: 'dashboard#index'

    resources :invitations, except: [:edit, :update]
  end

  resources :properties do
    resources :employees, only: [:new, :create],
              path_names: { new: 'new/:invitation_token' },
              controller: 'properties/employees' do
      get 'setup_payment' => 'properties/employees#setup_payment', as: :setup_payment
      post 'create_payment' => 'properties/employees#create_payment', as: :create_payment
      post 'create_address' => 'properties/employees#create_address', as: :create_address
      resources :invitations, path_names: { new: 'new' }
    end

    resources :users, except: [:new, :create, :edit, :update] do
      resources :transactions
    end
  end

  resources :employees, except: [:destroy], path_names: { new: 'new/:invitation_token' } do
    resources :properties, except: [:destroy], controller: 'employees/properties' do
      post 'update_tips' => 'employees/properties#update_suggested_tips', as: :update_tips
    end
    resources :property_employees, only: [:update, :destroy], controller: 'employees/property_employees'
  end

  resources :users do
    resources :property_users
    resources :transactions do
      get "review" => 'transactions#review', as: :review
      post "confirm" => 'transactions#confirm', as: :confirm
    end
    delete 'property/:id' => 'users#remove_property', as: :remove_property
  end
  
  get 'log_in' => 'sessions#new', as: :log_in
  post 'log_in' => 'sessions#create'
  match 'log_out' => 'sessions#destroy', as: :log_out, via: [:get, :post]

  root to: 'public#index'

  get 'about' => 'public#about', as: :about
  get 'tos' => 'public#tos', as: :tos
  get 'faq' => 'public#faq', as: :faq
  get 'privacy' => 'public#privacy', as: :privacy
  get 'contact' => 'public#contact', as: :contact
end
