# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'urls#index'

  resources :urls, only: %i[index create show], param: :url
  get ':short_url', to: 'urls#visit', as: :visit

  # API Routes
  namespace :api do
    jsonapi_resources :urls
    jsonapi_resources :clicks
  end
end
