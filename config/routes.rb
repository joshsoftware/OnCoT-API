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
          get 'candidate_test_time_left/:token', to: 'candidates#candidate_test_time_left'
        end
      end

      resources :candidates, only: %i[update show]
      post 'invite', to: 'candidates#invite'
      get '/drives/:id/problems' => 'problems#index'
      put 'accept_invite', to: 'users#accept_invite'
      resources :submissions, only: %i[create show]

      resources :drives do
        resources :results, only: [:index]
      end
      get 'drives/:token', to: 'drives#show'
      resources :drives_candidates, only: [:update]

      resources :executions do
        post :submission_token, on: :collection
        match :submission_result, on: :collection, via: %i[get put]
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

      resources :codes, only: %i[create] do
        get ':token/:problem_id', to: 'codes#show', on: :collection
        put ':token/:problem_id', to: 'codes#update', on: :collection
      end

      get '/drives/:drive_id/rules', to: 'rules#index'
      resources :snapshots, only: %i[index create] do
        post :presigned_url, on: :collection
      end

      namespace :admin do
        resources :problems, except: [:destroy]
        resources :reviewers
        resources :rules, except: %i[show]
        get '/default_rules' => 'rules#default_rules'
        post 'invite_user', to: 'users#invite_user'
        resources :users, only: %i[create update index]
        resources :drives, except: [:destroy]
        resources :test_cases, except: %i[destroy index]
        get '/problem/:problem_id/test_cases' => 'test_cases#index'
        get '/problems_list' => 'problems#problems_list'
        resources :drives do
          get :candidate_list, on: :member
          post :send_admin_email
        end
        resources :assessments, except: %i[destroy update show]
      end
    end
  end
end
