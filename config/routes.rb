# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]
  resources :languages, only: %i[index show] do
    get 'all', on: :collection
  end

  resources :drives do
    get :drive_time_left, on: :member
  end

  resources :drives do
    resources :candidates do
      get :candidate_test_time_left
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :reviewers
        resources :problems, except: [:destroy]
        resources :rules, except: %i[destroy index]
      end
    end
  end

  resources :candidates, only: [:update]
  get '/drives/:id/problem' => 'problems#index'
end
