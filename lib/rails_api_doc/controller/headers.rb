# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
module RailsApiDoc
  module Controller
    module Headers

      DESC_HEADER = {
        'Desc' => {
          value: lambda do |_row_name, row_values|
            row_values[:desc] || row_values.param&.desc || 'TODO: add description'
          end,
          fill_type: :input,
          param: :desc
        }
      }.freeze

      TYPE_HEADER = {
        'Type' => {
          value: lambda do |_row_name, row_values|
            row_values.display_type
          end,
          fill_type: :select,
          param: :type,
          values: RailsApiDoc::ACCEPTED_TYPES
        }
      }.freeze

      SPECIAL_HEADER = {
        'Special' => {
          value: lambda do |_row_name, row_values|
            row_values.display_special
          end,
          fill_type: :input,
          param: :special
        }
      }.freeze

      NAME_HEADER = {
        'Parameter' => {
          value: lambda do |row_name, row_values|
            row_values.display_name
          end,
          fill_type: :input,
          param: :name
        }
      }.freeze

      VALUE_HEADER = {
        'Value' => {
          value: lambda do |_row_name, row_values|
            row_values.display_value
          end
        }
      }.freeze

    end
  end
end
