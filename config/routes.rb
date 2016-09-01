# Match IDs with dots in them
id_pattern = /[^\/]+/

RailsApiDoc::Engine.routes.draw do

  root to: 'index#index'

end
