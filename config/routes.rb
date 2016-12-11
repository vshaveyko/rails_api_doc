# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# Match IDs with dots in them
# id_pattern = /[^\/]+/

RailsApiDoc::Engine.routes.draw do
  resource :api_doc

  root to: 'api_docs#show'
end
