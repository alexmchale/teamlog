RailsSkeleton::Application.routes.draw do

  resources :teams do
    resources :messages
    resources :members
  end

  resources :messages
  resources :password_resets
  resources :user_activations
  resources :user_sessions
  resources :users

  root :to => "teams#index"

end
