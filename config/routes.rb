Rails.application.routes.draw do
  resources :candidates

  resources :categories

  namespace :admin do
    resources :categories
    resources :elections
    resources :candidates
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  post 'votes', to: 'votes#create'
  get '/' => 'home#index'
  get '/election/:id', to: 'elections#show', as: :election
  get '/embed/election/:id', to: 'widget#show'
  get '/admin', to: 'admin/dashboard#index', as: :dashboard
end
