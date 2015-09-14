Rails.application.routes.draw do
  resources :candidates

  resources :categories

  namespace :admin do
    resources :categories
    resources :elections
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  post 'votes', to: 'votes#create'
  get '/' => 'home#index'
  get '/election/:id', to: 'elections#show', as: :election
  get '/categories', to: 'categories#index', as: :all_categories

  get '/embed/election/:id', to: 'widget#show'
  get '/admin', to: 'admin/dashboard#index', as: :dashboard
end
