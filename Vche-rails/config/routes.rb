Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, param: :uid
  resources :events, param: :uid do
    resources :event_schedules, param: :uid
    resources :event_histories, param: :time
  end

  get 'login' => 'sessions#new', :as => :login
  post 'login' => "sessions#create"
  post 'logout' => 'sessions#destroy', :as => :logout

  root :to => 'calendar#index'
end
