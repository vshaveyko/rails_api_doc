# author: Vadim Shaveiko <@vshaveyko>
# frozen_string_literal: true
module RailsApiDoc::Controller::StrongParams

  def resource_params
    # accepted_params for permit
    accepted_params = [{}]
    loop_params(params, permitted_params, accepted_params)
    params.permit(accepted_params)
  end

  private

  # loop through current level of params and add to permit level if all requirements are met
  #
  # requirements are: 1) if required is set - param must be present and not empty
  #                   2) if enum is set - param must equal predefined value
  #                   3) if config.check_params_type is set - param must be of required type
  #
  # @accepted_params = [{}] - array with last member hash for nesting
  # @level_params - current nesting level params
  # @level_permitted_params - data for params permission
  def loop_params(nested_controller_params, level_permitted_params, accepted_params)
    level_permitted_params.each do |param_name, api_param_data|
      controller_param = nested_controller_params[param_name]

      next unless RailsApiDoc::Config::Validator.valid_param?(controller_param, api_param_data)

      if api_param_data.nested?
        level_accepted_params = accepted_params.last[param_name] = [{}]
        next loop_params(controller_param, api_param_data, level_accepted_params)
      else
        accepted_params.unshift(param_name)
      end
    end
  end

  def permitted_params
    ::RailsApiDoc::Controller::Parameter::Repository[self]
  end

  def check_required_ok?(param_data, param_config)
    return true unless param_config.required?
    !param_data.blank?
  end

end
