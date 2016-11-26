# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
require_relative 'validate_ary_object'
require_relative 'validate_enum'
require_relative 'validate_type'

class RailsApiDoc::Config::Validator

  class << self

    attr_accessor :checkers

    def add_checker(klass)
      return if checkers.detect { |c| c.is_a?(klass) }

      checkers << klass.new
    end

    def remove_checker(klass)
      checkers.delete_if { |c| c.is_a?(klass) }
    end

    def valid_param?(controller_param, api_param_data)
      checkers.all? do |checker|
        checker.valid?(controller_param, api_param_data)
      end
    end

  end

  self.checkers = [RailsApiDoc::Config::ValidateEnum.new, RailsApiDoc::Config::ValidateAryObject.new]

end
