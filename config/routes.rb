# frozen_string_literal: true

Rails.application.routes.draw do
  get 'notifications/index'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root 'home#show'

  get 'get_started', to: 'home#show'
  # fix log warning
  get '/service-worker.js', to: 'service_workers#service_worker'
  resources :mpesa_transactions, only: %i[index]
  get 'mpesa_transaction/details', to: 'mpesa_transactions#details'
  get 'mpesa_transactions/top_up', to: 'mpesa_transactions#top_up'
  post 'mpesa_transactions/deposit', to: 'mpesa_transactions#deposit'
  # get 'mpesa_transactions/send_money_new', to: 'mpesa_transactions#send_money_new'
  # get 'mpesa_transactions/search', to: 'mpesa_transactions#search'
  post 'mpesa_transactions/send_money', to: 'mpesa_transactions#send_money'
  post 'mpesa_transactions/reverse', to: 'mpesa_transactions#reverse'
  resources :notifications, only: [:index]
  post 'notifications/mark_as_read', to: 'notifications#mark_as_read'
  resources :contacts, only: %i[index]
  get 'contacts/search', to: 'contacts#search'
  get 'contacts/mutuba', to: 'contacts#mutuba'
end
