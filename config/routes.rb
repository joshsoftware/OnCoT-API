# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]
  resources :languages, only: %i[index show] do
    get 'all', on: :collection
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :problems
      end
    end
  end
  resources :candidates, only: [:update]
  get '/drives/:id/problem' => 'problems#index'
end
