# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Config

  attr_accessor :check_params_type, :params_dir

  # init default values
  def initialize
    @params_dir = 'params'
  end

  def check_params_type=(value)
    if value
      Validator.add_checker(ValidateType)
    else
      Validator.remove_checker(ValidateType)
    end
  end

end
