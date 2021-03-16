# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]

  resources :executions do
    post :submission_token, on: :collection
    get :submission_status, on: :member
  end
  
  resources :languages, only: %i[index show] do
    get 'all', on: :collection
  end
  
  resources :candidates, only: [:update]
  get '/drives/:id/problem' => 'problems#index'
end
