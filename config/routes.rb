Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]
  resources :candidates, only: [:update] 
  resources :languages, only: %i[index show] do
    get 'all', on: :collection
  end

  post 'invite', to:'candidates#invite'
end
