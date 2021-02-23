Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :statuses, only: [:index]

  resources :languages, only: [:index, :show] do
    get 'all', on: :collection
  end
end
