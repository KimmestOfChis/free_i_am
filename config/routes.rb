# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [:create, :update, :destroy]
  get '*unmatched_route', to: 'errors#not_found'
end
