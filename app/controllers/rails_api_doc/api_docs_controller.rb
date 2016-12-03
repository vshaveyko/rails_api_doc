# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::ApiDocsController < RailsApiDoc::ApplicationController

  class NewRecord < ActiveRecord::Base
  end

  def index
    # preload controllers for parameters to apply
    Dir.glob("#{Rails.root}/app/controllers/**/*.rb").each { |file| require_dependency file }

    @request_repository = RailsApiDoc::Controller::Request::Repository

    @registered_controllers = @request_repository.registered_controllers

    @response_repository = RailsApiDoc::Controller::Response::Factory.repo
  end

  def create
    attributes = RailsApiDoc::Controller::AttributeParser.parse_attributes(permitted_params)

    RailsApiDoc::ApiDatum.create!(attributes)
  end

  def destroy
    attributes = RailsApiDoc::Controller::AttributeParser.parse_attributes(permitted_params)

    if params[:id]
      RailsApiDoc::ApiDatum.find(params[:id]).update!(attributes)
    else
      RailsApiDoc::ApiDatum.create!(attributes)
    end
  end

  def update
    attributes = RailsApiDoc::Controller::AttributeParser.parse_attributes(permitted_params)

    if params[:id]
      RailsApiDoc::ApiDatum.find(params[:id]).update!(attributes)
    else
      RailsApiDoc::ApiDatum.create!(attributes)
    end
  end

  private

  def permitted_params
    params.permit(:name, :type, :special, :desc)
  end

end
