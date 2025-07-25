Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    unlocks: "users/unlocks",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  
  devise_scope :user do
    get "/users/your_profile", to: "users/registrations#show", as: 'user_profile'
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "top#index"
  get "sorry", to: "top#sorry"

  resources :spots, only: %i[index new create show] do
    collection do
      get :search
    end
  end
  resources :favorites, only: %i[create destroy]
  resources :your_spots, only: %i[index show edit update destroy] do
    # [your_spots]の中に[your_spots/favorite]というGETリンクを作成する。
    collection do
      get :favorites
    end
  end
end
