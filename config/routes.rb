# Match IDs with dots in them
id_pattern = /[^\/]+/

RailsApiDoc::Engine.routes.draw do

  RailsApiDoc::Plugins.plugins.each do |p|
    mount p::Engine => p.engine_path
  end

  root to: 'index#index'

end
