# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
class RailsApiDoc::Controller::Parameter::Repository::Param

  ACCEPTED_TYPES = [String, Integer, Object, Array, DateTime, :enum, :model].freeze

  # @type - type to check
  def self.accepted_nested_type?(type)
    type == Object || type == :model
  end

  def self.valid_type?(type)
    return if type.in?(ACCEPTED_TYPES)
    raise ArgumentError, "Wrong type: #{type}. " \
                         "Correct types are: #{ACCEPTED_TYPES}."
  end

  def self.valid_enum?(enum)
    return if enum.nil? || enum.is_a?(Array)
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

  def nested?
    self.class.accepted_nested_type?(@store[:type])
  end

  def required?
    @store[:required]
  end

  def method_missing(name, *args)
    return @store.send(name, *args) if respond_to_missing?(name)
    super
  end

  def respond_to_missing?(name)
    @store.respond_to?(name)
  end

end
