# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::ApiDocsController < RailsApiDoc::ApplicationController

  class NewRecord < ActiveRecord::Base
  end

  def index
    # preload controllers for parameters to apply
    Dir.glob("#{Rails.root}/app/controllers/**/*.rb").each { |file| require_dependency file }

    @static_data = {
      types: RailsApiDoc::Controller::Parameter::Repository::Param::ACCEPTED_TYPES.map(&:to_s).freeze
    }
    @repository = RailsApiDoc::Controller::Parameter::Repository
  end

  def create
    attributes = RailsApiDoc::Controller::AttributeParser.parse_attributes(permitted_params)
  end

  def destroy
    pry binding
  end

  def edit
    @api_record = NewRecord.new

    pry binding
  end

  def new
    @api_record = NewRecord.new
    pry binding
  end

  def update

    pry binding
  end

  private

  def permitted_params
    params.permit!(:name, :type, :enum)
  end

end
