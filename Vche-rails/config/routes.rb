Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users do
    resource :password, controller: 'users/passwords', only: [:edit, :update]
  end

  resources :events do
    member do
      post :follow
      post :unfollow
    end
    resources :event_schedules
    resources :event_histories do
      resources :event_attendances, controller: 'events/event_histories/event_attendances', only: :index
      member do
        post :attend
        post :unattend
      end
    end
    resources :event_follows, controller: 'events/event_follows', only: :index
  end

  get 'login' => 'sessions#new', :as => :login
  post 'login' => "sessions#create"
  post 'logout' => 'sessions#destroy', :as => :logout

  root :to => 'calendar#index'
end
