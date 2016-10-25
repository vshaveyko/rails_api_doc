# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
Rails.application.routes.draw do
  resources :comments
  resources :data
  resources :authors
  resources :articles

  root 'authors#index'

  mount RailsApiDoc::Engine => '/api_doc'
end
