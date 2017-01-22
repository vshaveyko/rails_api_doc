# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
module RailsApiDoc
  module Controller
    module Request
      module DSL

        #
        # Use parameter in controller to define REQUEST parameter.
        # Adds it to repository: RailsApiDoc::Controller::Request::Repository
        # Params can be defined in several ways:
        # 1. parameter :name, type: :string
        #
        # 2. parameter {
        #   dose_form_attributes: { model: 'Rxnorm::RxDoseForm' },
        #   input_method_attributes: { model: 'TreatmentInfo::InputMethod' },
        #   input_condition_attributes: { model: 'Drugs::InputCondition' },
        #   input_duration_attributes: { model: 'Drugs::InputDuration' }
        # }, type: :object do
        #   parameter :id
        #   parameter :name
        # end
        #
        # 3. parameter :name, :code, type: :string
        #
        # 4. param :name, :string, model: 'Name'
        #
        def parameter(*arguments, &block)
          options = arguments.extract_options!

          raise ArgumentError, 'Parameter already defined.' if repo.key?(name)

          validate_options(options, block_given?)

          # 4)
          return if second_argument_type_def(options, arguments)

          arguments.each do |param|
            # 2)
            if param.is_a?(Hash)
              param.each do |param_name, additional_options|
                _options = options.merge(additional_options)

                define_parameter(param_name, _options, &block)
              end
            else # 1), 3)
              define_parameter(param, options, &block)
            end
          end
        end

        alias param parameter
        alias req parameter

        private

        def validate_options(options, _block_given)
          options.assert_valid_keys(RailsApiDoc::Controller::Param::VALID_KEYS)

          RailsApiDoc::Controller::Request::Param.valid_type?(options[:type])
        end

        # default repo can be reassigned to deal with nested parameters
        # see nested_parameter
        def repo
          @repo || RailsApiDoc::Controller::Request::Repository[self]
        end

        # adjust parameter values depending on parameter type
        # 1. if nested - add nested values to parameter_data on :nested key
        # 2. if enum - transform all values to_s
        #    bcs all incoming controller parameters will be strings and there can be errors
        def define_parameter(name, parameter_data, &block)
          if RailsApiDoc::Controller::Request::Param.valid_nested?(parameter_data[:type], block_given?)
            parameter_data = nested_parameter(parameter_data, &block)
          elsif RailsApiDoc::Controller::Request::Param.valid_enum?(parameter_data[:type], parameter_data[:enum])
            parameter_data[:enum].map!(:to_s)
          end

          repo[name] = RailsApiDoc::Controller::Request::Param.new(name, parameter_data)
        end

        def nested_parameter(parameter_data)
          backup_repo = @repo
          @repo = {}
          yield
          parameter_data.merge(nested: @repo)
        ensure
          @repo = backup_repo
        end

        #
        # Checks whetjher parameters can be defined by type 4)
        # if possible - do it
        # otherwise pass next
        #
        def second_argument_type_def(options, args)
          is_ok = second_argument_is_type?(args)

          return false unless is_ok
          param = args[0]
          options[:type] = args[1]

          define_parameter(param, options, &block)
          true
        end

        def second_argument_is_type?(args)
          RailsApiDoc::ACCEPTED_TYPES.include?(args[1].to_sym)
        end

      end
    end
  end
end
