# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::AttributeParser

  # TODO : Change to I18n. Added on: 08.10.16. Added by: <@vshaveyko>
  WRONG_NAME_ERROR_STRING = 'Name should consist only of letters\ciphers\underscores'

  class << self

    def parse_attributes(params)
      type = :enum if params[:enum].present?

      {
        name: parse_name(params[:name]),
        type: type || parse_type(params[:type]),
        enum: parse_enum(params[:enum])
      }.compact
    end

    private

    def parse_name(name_string)
      return if name_string.blank?
      raise ArgumentError, WRONG_NAME_ERROR_STRING unless name_string =~ /[A-z0-9_]*/
      name_string.underscore.to_sym
    end

    def parse_enum(enum_string)
      return if enum_string.blank?
      enum_string.split(',').map do |enum_value|
        parse_enum_value(enum_value)
      end
    end

    def parse_enum_value(value)
      case value
      when /^\d+$/
        value.to_i
      when 'true'
        true
      when 'false'
        false
      else
        value
      end
    end

    def parse_type(type)
      return if type.blank?
      type.constantize
    end

  end

end
