Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  get "candidate/:id" , to: "candidates#update"

  resources :statuses, only: [:index]

  resources :languages, only: [:index, :show] do
    get 'all', on: :collection
  end
end
