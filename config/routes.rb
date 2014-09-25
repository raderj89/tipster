Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create, :destroy] do
        post '/current_user' => 'sessions#get_current_user', on: :collection
      end
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

  get 'properties' => 'properties#index', as: :properties

  resources :employees, except: [:new, :destroy] do
    get "new/:invitation_token" => 'employees#new', as: :new, on: :collection
    member do
      get :setup_payment
      post :create_payment
      post :create_address 
      get :edit_deposit_method
      get :update_address
    end

    resources :property_employees, only: [:update, :destroy], controller: 'employees/property_employees'
    
    resources :properties, except: [:destroy], controller: 'employees/properties' do
      post :update_tips, on: :member
      resources :invitations
    end
  end

  resources :users do
    member do
      get :edit_payment_method
      post :update_payment_method
    end

    resources :property_users
    
    resources :properties do
      resources :transactions do
        member do
          get :review
          post :confirm
        end
      end
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
  get 'request_invitation' => 'public#request_invitation', as: :request_invitation

  post 'send_message' => 'public#send_message', as: :send_message
end
