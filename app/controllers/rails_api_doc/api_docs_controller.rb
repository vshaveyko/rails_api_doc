# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::ApiDocsController < RailsApiDoc::ApplicationController

  def show
    # preload controllers for parameters to apply
    Dir.glob("#{Rails.root}/app/controllers/**/*.rb").each { |file| require_dependency file }

    @registered_controllers = RailsApiDoc::Controller::Request::Factory.registered_controllers

    @request_repository = RailsApiDoc::Controller::Request::Factory.repo

    @response_repository = RailsApiDoc::Controller::Response::Factory.repo
  end

  def create
    attributes = RailsApiDoc::Model::AttributeParser.parse_attributes(params)
    pry binding

    @res = RailsApiDoc::ApiDatum.create!(attributes)

    redirect_to api_doc_path
  end

  def destroy
    if params[:id]
      @res = RailsApiDoc::ApiDatum.find(params[:id]).destroy!
    else
      attributes = RailsApiDoc::Model::AttributeParser.parse_attributes(params)

      @res = RailsApiDoc::ApiDatum.create!(attributes)
    end

    redirect_to api_doc_path
  end

  def update
    attributes = RailsApiDoc::Model::AttributeParser.parse_attributes(params)

    if params[:id]
      @res = RailsApiDoc::ApiDatum.find(params[:id]).update!(attributes)
    else
      @res = RailsApiDoc::ApiDatum.create!(attributes)
    end

    redirect_to api_doc_path
  end

end
