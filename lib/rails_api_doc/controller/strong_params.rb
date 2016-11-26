# author: Vadim Shaveiko <@vshaveyko>
# frozen_string_literal: true
module RailsApiDoc::Controller::StrongParams

  ParamIsRequired = Class.new(StandardError)

  def resource_params
    # accepted_params for permit
    params.permit(params_to_permit)
  end

  private

  def params_to_permit
    accepted_params = [{}]

    loop_params(params, permitted_params, accepted_params)

    accepted_params
  end

  # loop through current level of params and add to permit level if all requirements are met
  #
  # requirements are: 1) if required is set - param must be present and not empty => or error is raised
  #                   2) if enum is set - param must equal predefined value => see Config::ValidateEnum
  #                   3) if ary_object => see Config::ValidateAryObject
  #                   3) if config.check_params_type is set - param must be of required type
  #
  # @accepted_params = [{}] - array with last member hash for nesting
  # @level_params - current nesting level params
  # @level_permitted_params - data for params permission
  def loop_params(params, level_permitted_params, accepted_params)
    level_permitted_params.each do |param_name, api_param_data|
      controller_param = params[param_name]

      check_required(param_name, controller_param, api_param_data)
      #
      # no value present && not required => go next
      next unless controller_param

      next unless RailsApiDoc::Config::Validator.valid_param?(controller_param, api_param_data)

      # if settings is array
      if api_param_data.ary_object?
        controller_param.each do |single_controller_param|
          _next_nesting_level(single_controller_param, param_data: api_param_data, current_accepted_params: accepted_params, param_name: param_name)
        end
      elsif api_param_data.nested?
        _next_nesting_level(controller_param, param_data: api_param_data, current_accepted_params: accepted_params, param_name: param_name)
      else
        accepted_params.unshift(param_name)
      end
    end
  end

  def _next_nesting_level(controller_param, param_data:, current_accepted_params:, param_name:)
    level_accepted_params = current_accepted_params.last[param_name] = [{}]

    loop_params(controller_param, param_data.nesting, level_accepted_params)
  end

  def permitted_params
    ::RailsApiDoc::Controller::Parameter::Repository[self.class]
  end

  def check_required(param_name, param_data, param_config)
    return unless param_config.required? && param_data.blank?
    raise RailsApiDoc::Exception::ParamRequired, param_name
  end

end
