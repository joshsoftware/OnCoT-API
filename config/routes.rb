Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]

  resources :languages, only: %i[index show] do
    get 'all', on: :collection
  end

  resources :executions do
    post :submission_token, on: :collection
    get :submission_status, on: :member
  end
end
