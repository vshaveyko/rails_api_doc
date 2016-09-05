module RailsApiDoc::Controller::Parameter

  VALID_KEYS = [:type, :required, :enum] #:nodoc:

  # Use parameter in controller to defined REQUEST parameter.
  # Adds it to repository: RailsApiDoc::ParameterRepository
  def parameter(name, options, &block)
    if repo.key?(name)
      raise ArgumentError.new('Parameter already defined.')
    end

    validate_options(options, block_given?)

    define_parameter(name, options, &block)
  end

  private

  def validate_options(options, block_given)
    if options.nil? or options.empty?
      raise ArgumentError, 'Empty options passed.'
    end

    options.assert_valid_keys(VALID_KEYS)

    unless options[:type].in?(RailsApiDoc::Types::ACCEPTED_TYPES)
      raise ArgumentError.new("Wrong type: #{options[:type].inspect}. " \
                              "Correct types are: #{RailsApiDoc::Types::ACCEPTED_TYPES}.")
    end

    unless options[:enum].nil? or options[:enum].is_a?(Array)
      raise ArgumentError.new('Enum must be an array.')
    end

    if options[:type] == Object and not block_given
      raise ArgumentError.new('Empty object passed.')
    end
  end

  # default repo can be reassigned to deal with nested parameters
  # see nested_parameter
  def repo
    @repo || Repository[self]
  end

  def define_parameter(name, parameter_data, &block)
    if parameter_data[:type] == Object
      repo[name] = nested_parameter(parameter_data, &block)
    else
      repo[name] = parameter_data
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
