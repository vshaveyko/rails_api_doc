# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
module RailsApiDoc
  class IndexController < ApplicationController

    def index
      Dir.glob("#{Rails.root}/app/controllers/**/*.rb").each { |file| require_dependency file }

      @repository = RailsApiDoc::Controller::Parameter::Repository
    end

  end
end
