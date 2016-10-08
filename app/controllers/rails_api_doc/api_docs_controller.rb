# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::ApiDocsController < RailsApiDoc::ApplicationController

  def index
    # preload controllers for parameters to apply
    Dir.glob("#{Rails.root}/app/controllers/**/*.rb").each { |file| require_dependency file }

    @repository = RailsApiDoc::Controller::Parameter::Repository
  end

  def create
    RailsApiDoc::Controller::AttributeParser.parse_attributes(permitted_params)
  end

  private

  def permitted_params
    params.permit!(:name, :type, :enum)
  end
end
