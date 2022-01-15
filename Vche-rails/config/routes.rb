Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resource :heartbeat, only: :show
  end

  resource :home, controller: :home, only: :show

  namespace :my do
    resources :offline_schedules

    resources :events, only: [:index]
    resources :event_follow_requests, only: :index do
      member do
        post :accept
        post :decline
      end
    end

    resource :user do
      get :delete_form
      post :delete
    end

    resource :settings, only: [:show]
    resource :password, only: [:edit, :update]
  end

  resources :users, except: [:destroy] do
    member do
      get :info
      get :events
    end
    resources :accounts, controller: 'users/accounts' do
      member do
        get :info
      end
    end
    resources :event_memories, controller: 'users/event_memories'
  end

  resources :events do
    get :select, on: :new
    member do
      get :info
      post :follow
      post :unfollow
      post :add_user
      post :change_user
      post :remove_user
      get :appeal
    end
    resources :event_schedules
    resources :event_histories, controller: 'events/event_histories' do
      resources :event_attendances, controller: 'events/event_histories/event_attendances', only: :index
      member do
        get :info
        post :attend
        post :unattend
        post :add_user
        post :change_user
        post :remove_user
        get :appeal
      end
      resource :resolution, controller: 'events/event_histories/resolutions', only: [:edit, :update]
      resource :reschedule, controller: 'events/event_histories/reschedules', only: [:new, :create]
    end
    resources :event_follows, controller: 'events/event_follows', only: :index
    resources :event_follow_requests, controller: 'events/event_follow_requests', only: :index do
      member do
        post :withdraw
      end
    end

    resource :owner, controller: 'events/owners', only: [:edit, :update] do
      get :introduction
    end
    resource :visibility, controller: 'events/visibilities', only: [:show, :edit, :update]
    resource :settings, controller: 'events/settings', only: [:show]
  end

  resources :hashtags, only: [:index, :show]

  get 'login' => 'sessions#new', :as => :login
  post 'login' => "sessions#create"
  post 'logout' => 'sessions#destroy', :as => :logout
  post '/sessions/purge' => 'sessions#purge', :as => :purge_sessions

  get 'oauth/:provider/oauth', to: 'oauths#oauth', :as => :auth_at_provider
  get 'oauth/:provider/callback', to: 'oauths#callback'

  get 'tos' => 'agreements#tos', :as => :tos
  get 'privacy_policy' => 'agreements#privacy_policy', :as => :privacy_policy

  resources :agreements, only: [] do
    collection do
      get :confirm
      post :agree
    end
  end

  resource :recovery, only: [:new, :create]

  resources :feedbacks, only: [:new, :create] do
    collection do
      get :done
    end
  end

  root :to => 'calendar#index'

  direct :support_email do
    Rails.application.config.x.vche.support_email
  end

  direct :support_github do
    Rails.application.config.x.vche.support_github
  end

  direct :support_twitter do
    Rails.application.config.x.vche.support_twitter
  end

  direct :support_discord do
    Rails.application.config.x.vche.support_discord
  end

  ActiveAdmin.routes(self)
end
