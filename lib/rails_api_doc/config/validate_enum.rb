# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Config::ValidateEnum

  #
  # @api_param_data - RailsApiDoc::Controller::Ruquest::Param
  # @controller_param - ActionController::Parameter
  #
  # check validation of current type by given data
  #
  # enum: check that enum array includes given value
  #
  def valid?(controller_param, api_param_data)
    return true unless api_param_data.enum?

    api_param_data[:enum].include?(controller_param)
  end

end
