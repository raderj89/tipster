Rails.application.routes.draw do

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

  resources :employees, path_names: { new: 'new/:invitation_token' }

  resources :users do
    delete 'property/:id' => 'users#remove_property', as: :remove_property
  end
  
  get 'log_in' => 'sessions#new', as: :log_in
  post 'log_in' => 'sessions#create'
  match 'log_out' => 'sessions#destroy', as: :log_out, via: [:get, :post]

  root to: 'public#index'
end
