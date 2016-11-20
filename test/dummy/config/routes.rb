# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
Rails.application.routes.draw do
  scope module: :test do
    resources :comments do
      get 'module_test_member_route'
      get 'module_test_collection_route', on: :collection
    end
  end

  namespace :api do
    resources :data do
      get 'api_member_route'
      get 'api_collection_route', on: :collection
    end
  end

  resources :authors do
    get 'member_route'
    get 'collection_route', on: :collection
  end

  scope :test do
    resources :articles do
      get 'test_member_route'
      get 'test_collection_route', on: :collection
    end
  end

  root 'authors#index'

  mount RailsApiDoc::Engine => '/api_doc'
end
