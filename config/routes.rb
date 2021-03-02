Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]
  
  resources :drives do
    get :drive_time_left, on: :member
  end

  resources :languages, only: [:index, :show] do
    get 'all', on: :collection
  end
end
