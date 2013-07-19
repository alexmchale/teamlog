RailsSkeleton::Application.routes.draw do

  get "members/new"

  resources :teams do
    resources :messages
    resources :members
  end

  resources :messages
  resources :users
  resources :user_sessions

  root :to => "messages#index"

end
