# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

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
        resources :problems, except: [:destroy]
        resources :reviewers
        resources :drives, except: %i[create update]
        post '/drives/problem/:problem_id' => 'drives#create'
        put '/drives/problem/:problem_id' => 'drives#update'
        resources :test_cases, except: %i[destroy index]
        get '/problem/:problem_id/test_cases' => 'test_cases#index'
      end
    end
  end

  resources :candidates, only: [:update]
  get '/drives/:id/problem' => 'problems#index'
end
