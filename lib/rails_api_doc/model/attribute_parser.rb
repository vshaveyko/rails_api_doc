# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Model::AttributeParser

  # TODO : Change to I18n. Added on: 08.10.16. Added by: <@vshaveyko>
  WRONG_NAME_ERROR_STRING = 'Name should consist only of letters\ciphers\underscores'
  WRONG_TYPE_ERROR_STRING = 'Wrong type saved'

  class << self

    def parse_attributes(params)
      {
        name: parse_name(params[:name]),
        type: parse_type(params[:type]),
        desc: params[:desc],
        special: parse_special(params[:type], params[:special]),
        action_type: params[:action],
        nesting: params[:nesting],
        api_type: params[:api_type],
        api_action: params[:api_action],
        id: params[:id]
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

    def parse_special(type, special)
      return unless special.present? && type

      if type == :enum
        parse_enum(special) # parse as enum array value
      elsif RailsApiDoc::NESTED_TYPES.include?(type.to_sym)
        special.capitalize # parse as model name
      end
    end

    def parse_type(type)
      return if type.blank?

      type = type.to_sym
      raise NameError, WRONG_TYPE_ERROR_STRING unless type.in?(RailsApiDoc::ACCEPTED_TYPES)

      type
    end

  end

end
