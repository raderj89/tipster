Rails.application.routes.draw do

  namespace :admin do
    get 'log_in' => 'sessions#new', as: :log_in
    post 'log_in' => 'sessions#create'
    match 'log_out' => 'sessions#destroy', as: :log_out, via: [:get, :post]
    root to: 'dashboard#index'

    resources :invitations, except: [:edit, :update]
  end

  resources :properties, except: [:new] do
    resources :property_employees, except: [:new]
    resources :employees do
      get 'setup_payment' => 'employees#setup_payment', as: :setup_payment
      post 'create_payment' => 'employees#create_payment', as: :create_payment
      post 'create_address' => 'employees#create_address', as: :create_address
      resources :invitations
      resources :employee_addresses
    end
  end


  get 'properties/:property_id/property_employees/new/:invitation_token' => 'property_employees#new', as: :new_property_property_employee
  get 'properties/new/:invitation_token' => 'properties#new', as: :new_property


  root to: 'public#index'
end
