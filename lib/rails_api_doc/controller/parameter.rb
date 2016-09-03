module RailsApiDoc::Controller::Parameter

  # Use parameter in controller to defined REQUEST parameter.
  # Adds it to repository: RailsApiDoc::ParameterRepository
  def parameter(name, type: :enum, enum: nil, &block)
    if repo.key?(name)
      raise ArgumentError.new('Parameter already defined.')
    end

    unless type.in?(RailsApiDoc::Types::ACCEPTED_TYPES)
      raise ArgumentError.new('Wrong type:' + type.inspect + ". Correct types are: #{RailsApiDoc::Types::ACCEPTED_TYPES}.")
    end

    unless enum.nil? or enum.is_a?(Array)
      raise ArgumentError.new('Enum must be an array.')
    end

    if type == Object and not block_given?
      raise ArgumentError.new('Empty object passed.')
    end

    define_parameter(name, type, enum, &block)
  end

  private

  # default repo can be reassigned to deal with nested parameters
  # see nested_parameter
  def repo
    @repo || Repository[self]
  end

  def define_parameter(name, type, enum, &block)
    parameter_data = { type: type, enum: enum }

    if type == Object
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
