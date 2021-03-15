# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :statuses, only: [:index]
  resources :candidates, only: [:update]
  resources :languages, only: %i[index show] do
    get 'all', on: :collection
  end

  resources :drives do
    get :drive_time_left, on: :member
  end

  resources :drives do
    resources :candidates do
      get :candidate_test_time_left
    end
  end
end
