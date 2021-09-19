Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :home, controller: :home, only: :show do
    get :events
  end

  resources :users do
    member do
      get :events
    end
    resource :password, controller: 'users/passwords', only: [:edit, :update]
  end

  resources :events do
    member do
      post :follow
      post :unfollow
      post :add_user
      post :remove_user
    end
    resources :event_schedules
    resources :event_histories, controller: 'events/event_histories' do
      resources :event_attendances, controller: 'events/event_histories/event_attendances', only: :index
      member do
        post :attend
        post :unattend
        post :add_user
        post :remove_user
      end
    end
    resources :event_follows, controller: 'events/event_follows', only: :index
    resource :visibility, controller: 'events/visibilities', only: [:edit, :update]
  end

  get 'login' => 'sessions#new', :as => :login
  post 'login' => "sessions#create"
  post 'logout' => 'sessions#destroy', :as => :logout

  root :to => 'calendar#index'
end
