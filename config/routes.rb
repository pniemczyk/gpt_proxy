# frozen_string_literal: true

Rails.application.routes.draw do
  resources :profiles
  resources :providers, except: %i[new create] do
    member do
      get :models
      post :ask
      post :completions
      post :chat
      get :refresh_docs
    end
  end

  resources :live, only: :index do
    get :chat, on: :collection, as: :chat_default
    get :chat, on: :collection, as: :chat, path: 'chat/:provider_id'
  end

  root 'welcome#index'
  get 'up' => 'rails/health#show', as: :rails_health_check

  if Rails.env.development?
    mount Lookbook::Engine, at: '/rails/lookbook', as: :lookbook
  end
end
