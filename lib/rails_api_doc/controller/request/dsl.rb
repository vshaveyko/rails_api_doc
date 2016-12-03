# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
module RailsApiDoc
  module Controller
    module Request
      module DSL

        VALID_KEYS = [:type, :required, :enum, :model, :desc, :value].freeze #:nodoc:

        # Use parameter in controller to define REQUEST parameter.
        # Adds it to repository: RailsApiDoc::Controller::Request::Repository
        def parameter(name, options = {}, &block)
          raise ArgumentError, 'Parameter already defined.' if repo.key?(name)

          validate_options(options, block_given?)

          define_parameter(name, options, &block)
        end

        private

        def validate_options(options, block_given)
          options.assert_valid_keys(VALID_KEYS)

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
          _backup_repo = @repo
          @repo = {}
          yield
          parameter_data.merge(nested: @repo)
        ensure
          @repo = _backup_repo
        end

      end
    end
  end
end
