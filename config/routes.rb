Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]
  resources :candidates, only: [:update]
  resources :languages, only: %i[index show] do
    get 'all', on: :collection
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :reviewers
      end
    end
  end

  root 'api/v1/admin/reviewers#index'
end
