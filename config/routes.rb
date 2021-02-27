Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]

  get '/drive/:id', to "drives#drive_time_left"

  resources :languages, only: [:index, :show] do
    get 'all', on: :collection
  end
end
