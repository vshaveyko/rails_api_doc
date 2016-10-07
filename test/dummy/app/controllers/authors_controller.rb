# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
class AuthorsController < ApplicationController

  has_scope :article_id, :name

  # Define parameters with type and nested options
  parameter :age, type: Integer
  parameter :name, type: String, required: true
  parameter :articles, type: :model, model: Article do
    parameter :title, type: String
    parameter :body, type: String, required: true
    parameter :rating, type: :enum, enum: [1,2,3]
    parameter :data, type: :model, model: Datum do
      parameter :creation_date, type: DateTime
      parameter :comment, type: String
    end
  end

end
