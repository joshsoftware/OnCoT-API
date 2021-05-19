# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
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

      resources :candidates, only: %i[update show]
      post 'invite', to: 'candidates#invite'
      get '/drives/:id/problem' => 'problems#index'

      resources :submissions, only: %i[create show]

      resources :drives do
        resources :results, only: [:index]
      end
      get 'drives/:token', to: 'drives#show'
      resources :drives_candidates, only: [:update]

      resources :executions do
        post :submission_token, on: :collection
        put :submission_result, on: :collection
        get :submission_status, on: :member
      end

      resources :drives do
        resources :problems do
          resources :candidate_results, only: [:show]
        end
        resources :results do
          get :csv_result, on: :collection
        end
      end

      resources :drives_candidates do
        get :show_code
      end

      get '/drives/:drive_id/rules', to: 'rules#index'

      namespace :admin do
        resources :problems, except: [:destroy]
        resources :reviewers
        resources :rules, except: %i[show]
        resources :users, only: %i[create update]
        resources :drives, except: [:destroy]
        resources :test_cases, except: %i[destroy index]
        get '/problem/:problem_id/test_cases' => 'test_cases#index'
        get '/problems_list' => 'problems#problems_list'
        resources :drives do
          get :candidate_list, on: :member
          post :send_admin_email
        end
      end
    end
  end
end
