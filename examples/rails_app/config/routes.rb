# frozen_string_literal: true

Rails.application.routes.draw do
  root 'resources#index'

  resources :resources, only: [:index, :show]
  resources :users, only: [:index]
  resources :access_rules, only: [:index, :new, :create, :edit, :update]
end
