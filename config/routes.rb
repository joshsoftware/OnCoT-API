Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]
  resources :problems, only: [:show] 
  #resources :candidates, only: [:update] 
  resources :rules, only: [:show] 
  resources :languages, only: %i[index show] do
    get 'all', on: :collection
  end

  post 'invite', to:'candidates#invite'
  get 'drives/:token', to: 'drives#show'
  post '/token', to: 'executions#submission_token'
  get '/submission/:token', to: 'executions#submission_status'
  patch '/candidates/:token', to: 'candidates#update'

end
