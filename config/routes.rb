RailsSkeleton::Application.routes.draw do

  resources :messages
  resources :users
  resources :user_sessions

  root :to => "messages#index"

end
