# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::ApiDocsController < RailsApiDoc::ApplicationController

  after_action :render_json, only: [:create, :destroy, :update]

  def index
    # preload controllers for parameters to apply
    Dir.glob("#{Rails.root}/app/controllers/**/*.rb").each { |file| require_dependency file }

    @request_repository = RailsApiDoc::Controller::Request::Factory.repo

    @registered_controllers = @request_repository.registered_controllers

    @response_repository = RailsApiDoc::Controller::Response::Factory.repo
  end

  def create
    attributes = RailsApiDoc::Model::AttributeParser.parse_attributes(params)

    @res = RailsApiDoc::ApiDatum.create!(attributes)
  end

  def destroy
    attributes = RailsApiDoc::Model::AttributeParser.parse_attributes(params)

    if params[:id]
      @res = RailsApiDoc::ApiDatum.find(params[:id]).update!(attributes)
    else
      @res = RailsApiDoc::ApiDatum.create!(attributes)
    end
  end

  def update
    attributes = RailsApiDoc::Model::AttributeParser.parse_attributes(params)

    if params[:id]
      @res = RailsApiDoc::ApiDatum.find(params[:id]).update!(attributes)
    else
      @res = RailsApiDoc::ApiDatum.create!(attributes)
    end
  end

  private

  def render_json
    render json: @res.as_json, status: :ok
  end

end
