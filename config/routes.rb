# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

require "sidekiq/web"

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  # Secure access to Sidekiq Web Monitor in production
  if Rails.env.production?
    # Insert Rack middleware to require basic auth
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Use secure_compare to stop length information leaking.
      # Use & instead of && so it doesn't short circuit.
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(ENV.fetch("SIDEKIQ_USERNAME", "Admin User"))
      ) & ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(ENV.fetch("SIDEKIQ_PASSWORD", "SecurePassword123"))
      )
    end
  end

  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      post "/login", to: "sessions#create"

      post "/refresh", to: "refresh#create"

      get "/health", to: "health#index"

      resources :users, only: [ :index, :show, :create, :update, :destroy ] do
        resource :settings, controller: "user_settings", only: [ :show, :update ]
      end

      resources :courses, only: [ :index, :show, :create, :update, :destroy ] do
        collection do
          get :published, to: "courses/publications#index"
        end

        member do
          post :publish, to: "courses/publications#create"
        end

        member do
          post :unpublish, to: "courses/publications#destroy"
        end

        collection do
          get :drafts, to: "courses/drafts#index"
        end

        resources :enrollments, only: [ :index, :create ]
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
