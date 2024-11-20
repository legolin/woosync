Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :products do
    collection do
      get "batch_edit"
      get "batch_delete"
      post "batch_update"
      get "batch_update_progress"
      post "do_batch_delete"
    end
  end

  resources :feeds do
    resources :mappings do
      collection do
        post :from_file
        get :batch_edit
        patch :batch_update
      end
    end
  end

  resources :imports do
    collection do
      get :choose_upload, as: :choose_import_file
    end
  end
  resources :suppliers
  resources :exports

  # Defines the root path route ("/")
  root "products#index"
end
