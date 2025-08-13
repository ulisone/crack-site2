Rails.application.routes.draw do
  # Software Crackz Routes
  root 'softwares#index'
  
  # Public software browsing
  resources :softwares, only: [:index, :show] do
    resources :downloads, only: [:show]
  end
  
  resources :categories, only: [:index, :show]
  
  # Admin area
  namespace :admin do
    root 'dashboard#index'
    resources :softwares do
      member do
        delete 'remove_attachment/:attachment_id', to: 'softwares#remove_attachment', as: :remove_attachment
      end
    end
    resources :categories
    resources :downloads, only: [:index, :show]
  end
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files (commented out for now)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
