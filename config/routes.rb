Rails.application.routes.draw do
  
  namespace :admin do
    get 'log_in' => 'sessions#new', as: :log_in
    post 'log_in' => 'sessions#create'
    match 'log_out' => 'sessions#destroy', as: :log_out, via: [:get, :post]
    root to: 'dashboard#index'

    resources :invitations, except: [:edit, :update]
  end

  resources :properties, except: [:new], shallow: true do
    resources :employees do
      resources :invitations
      get 'setup_payment' => 'employees#setup_payment', as: :setup_payment
    end
  end

  get 'properties/new/:invitation_token' => 'properties#new', as: :new_property


  root to: 'public#index'
end
