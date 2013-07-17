RailsSkeleton::Application.routes.draw do

  resources :users
  resources :user_sessions

  root :to => "user_sessions#new"

end
