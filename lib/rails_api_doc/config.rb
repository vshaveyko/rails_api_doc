# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Config

  attr_accessor :check_params_type

  def check_params_type=(value)
    if value
      Validator.add_checker(ValidateType)
    else
      Validator.remove_checker(ValidateType)
    end
  end

end

require_relative 'config/validator'
