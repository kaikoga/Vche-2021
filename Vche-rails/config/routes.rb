Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users
  resources :events

  get 'login' => 'sessions#new', :as => :login
  post 'login' => "sessions#create"
  post 'logout' => 'sessions#destroy', :as => :logout

  root :to => 'events#index'
end
