Rails.application.routes.draw do
  resources :comments
  resources :data
  resources :authors
  resources :articles
  mount RailsApiDoc::Engine => "/api_doc"
end
