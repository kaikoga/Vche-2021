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
    resources :event_histories
  end

  get 'login' => 'sessions#new', :as => :login
  post 'login' => "sessions#create"
  post 'logout' => 'sessions#destroy', :as => :logout

  root :to => 'calendar#index'
end
