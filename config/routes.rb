Rails.application.routes.draw do
  get "wordsearch/show"
  resource :session
  resources :passwords, param: :token, except: [ :index, :destroy, :show ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "weeks#index"
  get "login" => "sessions#new", as: :login
  delete "logout" => "sessions#destroy", as: :logout

  resource :users

  resources :weeks  do
    resources :practice, only: [ :show, :update ]
    resources :scramble, only: [ :index ]
    resources :guess, only: [ :show ] do
      post :try, on: :member
    end
  end

  resources :wordsearch, only: [ :show ] do
    post :progress, on: :member
  end
end
