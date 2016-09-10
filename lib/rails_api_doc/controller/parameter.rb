# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
module RailsApiDoc::Controller::Parameter

  VALID_KEYS = [:type, :required, :enum].freeze #:nodoc:

  # Use parameter in controller to defined REQUEST parameter.
  # Adds it to repository: RailsApiDoc::Controller::Parameter::Repository
  def parameter(name, options, &block)
    raise ArgumentError, 'Parameter already defined.' if repo.key?(name)

    validate_options(options, block_given?)

    define_parameter(name, options, &block)
  end

  private

  def validate_options(options, block_given)
    if options.nil? || options.empty?
      raise ArgumentError, 'Empty options passed.'
    end

    options.assert_valid_keys(VALID_KEYS)

    Param.valid_type?(options[:type])

    Param.valid_enum?(options[:enum])

    Param.valid_nested?(options[:type], block_given)
  end

  # default repo can be reassigned to deal with nested parameters
  # see nested_parameter
  def repo
    @repo || Repository[self]
  end

  def define_parameter(name, parameter_data, &block)
    repo[name] = if Param.valid_nested?(parameter_data[:type], block_given?)
                   nested_parameter(parameter_data, &block)
                 else
                   parameter_data
                 end
  end

  def nested_parameter(parameter_data)
    @repo = {}
    yield
    parameter_data.merge!(nested: @repo)
  ensure
    @repo = nil
  end

end
