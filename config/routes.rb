Rails.application.routes.draw do
  
  namespace :admin do
    get 'log_in' => 'sessions#new', as: :log_in
    post 'log_in' => 'sessions#create'
    post 'log_out' => 'sessions#destroy', as: :log_out
    root to: 'dashboard#index'

    resources :invitations, except: [:edit, :update]
  end

  root to: 'public#index'
end
