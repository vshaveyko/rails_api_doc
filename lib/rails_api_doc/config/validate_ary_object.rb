# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
class RailsApiDoc::Config::ValidateAryObject

  #
  # @api_param_data - RailsApiDoc::Controller::Request::Param
  # @controller_param - ActionController::Parameter
  #
  # check validation of current type by given data
  #
  # ary_object: check that parameter is array of parameters
  #
  def valid?(controller_param, api_param_data)
    return true unless api_param_data.ary_object?

    controller_param.is_a?(Array) && begin
      controller_param.all? { |param| param.is_a?(::ActionController::Parameters) }
    end
  end

end
