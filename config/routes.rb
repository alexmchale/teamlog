RailsSkeleton::Application.routes.draw do

  resources :teams do
    resources :messages
  end

  resources :messages
  resources :users
  resources :user_sessions

  root :to => "messages#index"

end
