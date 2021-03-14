Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :statuses, only: [:index]
  
  resources :drives do
    get :drive_time_left, on: :member
  end

  resources :languages, only: [:index, :show] do
    get 'all', on: :collection
  end

  # resources :candidates, only: [:candidate_test_time_left]

  resources :drives do
    resources :candidates do
      get :candidate_test_time_left
    end
  end
  
end
