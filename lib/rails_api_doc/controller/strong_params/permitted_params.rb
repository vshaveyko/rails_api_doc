# author: Vadim Shaveiko <@vshaveyko>
# frozen_string_literal: true
module RailsApiDoc
  module Controller
    module ResourceParams
      module PermittedParams

        private

        def params_to_permit(pars = params)
          _next_nesting_level(pars, param_data: _permitted_params)
        end

        def _permitted_params
          ::RailsApiDoc::Controller::Request::Repository[self.class]
        end

        #
        # iterate recursively
        # level_accepted_params initted as [{}] bcs params permit accepts
        # aray with hash as a last arguments for describing nesting levels
        #
        def _next_nesting_level(controller_param, param_data:, current_accepted_params: nil, param_name: nil)
          level_accepted_params = [{}]

          if param_name && current_accepted_params # no param name and current_accepted_params on first iteration
            current_accepted_params.last[param_name] = level_accepted_params
          end

          loop_params(controller_param, param_data, level_accepted_params)

          level_accepted_params
        end

        #
        # loop through current level of params and add to permit level if all requirements are met
        #
        # requirements are: 1) if required is set - param must be present and not empty => or error is raised
        #                   2) if enum is set - param must equal predefined value => see Config::ValidateEnum
        #                   3) if ary_object => see Config::ValidateAryObject
        #                   3) if config.check_params_type is set - param must be of required type
        #
        # @accepted_params = [{}] - array with last member hash for nesting
        # @params - current nesting level params
        # @level_permitted_params - data for params permission
        #
        def loop_params(params, level_permitted_params, accepted_params)
          level_permitted_params.each do |param_name, api_param_data|
            if api_param_data.value&.respond_to?(:call)
              params[param_name] = api_param_data.value.call(params[param_name])
            end

            controller_param = params[param_name]

            _check_required(param_name, controller_param, api_param_data) # raise if required and no value

            # no value present && not required => skip
            next unless controller_param

            # value present but not valid for this type => skip
            next unless RailsApiDoc::Config::Validator.valid_param?(controller_param, api_param_data)

            if api_param_data.ary_object? # controller_param value should be array of objects
              controller_param.each do |single_controller_param|
                _next_nesting_level(single_controller_param,
                                    param_data: api_param_data.nested,
                                    current_accepted_params: accepted_params,
                                    param_name: param_name)
              end
            elsif api_param_data.nested? # value should be nested object
              _next_nesting_level(controller_param,
                                  param_data: api_param_data.nested,
                                  current_accepted_params: accepted_params,
                                  param_name: param_name)

            else # all other options
              accepted_params.unshift(param_name)
            end
          end
        end

        def _check_required(param_name, param_data, param_config)
          return unless param_config.required? && param_data.blank?
          raise RailsApiDoc::Exception::ParamRequired, param_name
        end

      end
    end
  end
end
