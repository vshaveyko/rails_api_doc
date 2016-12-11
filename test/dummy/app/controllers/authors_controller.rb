# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
class AuthorsController < ApplicationController

  has_scope :article_id, :name

  # Define parameters with type and nested options
  parameter :age, type: :integer
  parameter :name, type: :string, required: true
  parameter :articles_attributes, type: :model, model: 'Article' do
    parameter :title, type: :string
    parameter :body, type: :string, required: true
    parameter :rating, type: :enum, enum: [1, 2, 3]
    parameter :data_attributes, type: :model, model: 'Datum' do
      parameter :creation_date, type: :datetime
      parameter :comment, type: :string
    end
  end
  parameter :test, type: :string, required: true

  def member_route
  end

  def collection_route
  end

  def index
  end

  def show
  end

  def create
  end

  def update
  end

end
