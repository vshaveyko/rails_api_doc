# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
class RailsApiDoc::Controller::Parameter::Repository::Param

  NESTED_TYPES = [:ary_object, :object, :model, Object].freeze

  STRAIGHT_TYPES = [:bool, :string, :integer, :array, :datetime, :enum, String, Object, Integer, Array, DateTime].freeze

  ACCEPTED_TYPES = (NESTED_TYPES + STRAIGHT_TYPES).freeze

  # @type - type to check
  def self.accepted_nested_type?(type)
    type.in?(NESTED_TYPES)
  end

  def self.valid_type?(type)
    return if type.nil? || type.in?(ACCEPTED_TYPES)
    raise ArgumentError, "Wrong type: #{type}. " \
                         "Correct types are: #{ACCEPTED_TYPES}."
  end

  def self.valid_enum?(type, enum)
    return false unless type == :enum
    return if enum.is_a?(Array)
    raise ArgumentError, 'Enum must be an array.'
  end

  def self.valid_nested?(type, block_given)
    return false unless accepted_nested_type?(type)
    return true if block_given
    raise ArgumentError, 'Empty object passed.'
  end

  def initialize(name, store)
    @name = name
    @store = store
  end

  def enum?
    @store[:type] == :enum && @store[:enum].present?
  end

  def ary_object?
    @store[:type] == :ary_object
  end

  def nested?
    self.class.accepted_nested_type?(@store[:type])
  end

  def nesting
    @store[:nested]
  end

  def required?
    @store[:required]
  end

  def method_missing(name, *args)
    return @store.public_send(name, *args) if respond_to_missing?(name)
    super
  end

  def respond_to_missing?(name)
    @store.respond_to?(name)
  end

end
