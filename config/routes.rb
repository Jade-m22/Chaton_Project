Rails.application.routes.draw do
  root to: "products#index"

  devise_for :users
  resources :users, only: %i[index show edit update destroy]
  resources :orders, only: [:index, :show, :create, :update, :destroy] do
    member do
      get :checkout
      get :success  # ✅ Redirige ici après paiement réussi
      get :cancel   # ❌ Redirige ici après paiement échoué
    end
  end  

  delete "/logout", to: "users#logout", as: :logout

  resources :products

  resource :cart, only: [:show] do
    post "add_item/:product_id", to: "carts#add_item", as: "add_item"
    delete "remove_item/:id", to: "carts#remove_item", as: "remove_item"
    delete "empty", to: "carts#empty", as: "empty"
    patch "update_quantity/:id", to: "carts#update_quantity", as: "update_quantity"
  end
  

  get "/dashboard", to: "users#dashboard", as: :dashboard

  # Ajout de la route pour la page "À propos"
  get "/about", to: "application#about", as: :about

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
