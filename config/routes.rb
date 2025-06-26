Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "top#index"
  resources :spots, only: %i[index new create show] 
  resources :favorites, only: %i[create destroy]
  resources :your_spots, only: %i[index show edit update destroy] do
    # [your_spots]の中に[your_spots/favorite]というGETリンクを作成する。
    collection do
      get :favorites
    end
  end
  resource :your_profile, only: %i[show edit update destroy]
  
  # Google認証
  # Googleからの認証コールバックを受け取る
  get 'auth/:provider/callback', to: 'sessions#create'
  # 認証に失敗した場合、ルートパス（/）にリダイレクト
  get 'auth/failure', to: redirect('/')
  # ログアウトリクエストを処理し、「as: 'logout'」で[logout_path]というヘルパーメソッドを定義。
  post 'logout', to: 'sessions#destroy', as: 'logout'

end
