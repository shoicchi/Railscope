# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'top#index'
  get '/notes/hashtag/:tag_name', to: 'users/notes#hashtag'
  post '/subscriptions/new' => 'users/subscriptions#registration_payjp'
  post '/subscriptions' => 'users/subscriptions#monthly_subscription'
  post 'likes/:note_id/create', to: 'users/likes#create', constraints: { note_id: /\d+/ }, as: :likes_create
  post 'likes/:note_id/delete', to: 'users/likes#delete', constraints: { note_id: /\d+/ }, as: :likes_delete

  # NOTE: github認証のため以下記載
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :users do
    resources :my_notes, :points, :users, :subscriptions, :bookmarks
  end

  scope module: :users do
    resources :notes do
      resources :reviews, :postscripts
    end
  end
end
