# :nodoc:
class RailsApiDoc::Controller::AttributeParser

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
      name_string.underscore
    end

    def parse_enum(enum_string)
      return if name_string.blank?

    end

  end
end
