Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :home, controller: :home, only: :show do
    get :events
  end

  resources :users do
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
    resource :password, controller: 'users/passwords', only: [:edit, :update]
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
      end
      resource :resolution, controller: 'events/event_histories/resolutions', only: [:edit, :update]
    end
    resources :event_follows, controller: 'events/event_follows', only: :index

    resource :owner, controller: 'events/owners', only: [:edit, :update] do
      get :introduction
    end
    resource :visibility, controller: 'events/visibilities', only: [:edit, :update]
  end

  resources :hashtags, only: [:index, :show]

  get 'login' => 'sessions#new', :as => :login
  post 'login' => "sessions#create"
  post 'logout' => 'sessions#destroy', :as => :logout

  get 'tos' => 'agreements#tos', :as => :tos
  get 'privacy_policy' => 'agreements#privacy_policy', :as => :privacy_policy

  resources :feedbacks, only: [:new, :create] do
    collection do
      get :done
    end
  end

  root :to => 'calendar#index'

  ActiveAdmin.routes(self)
end
