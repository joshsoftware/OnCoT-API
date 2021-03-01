Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]
  resources :candidate, only: [:create, :update] do
    get '/candidate', to: 'candidates#create'
    put '/candidate/:id', to: 'candidates#update'
  end
  resources :languages, only: [:index, :show] do
    get 'all', on: :collection
  end
end
