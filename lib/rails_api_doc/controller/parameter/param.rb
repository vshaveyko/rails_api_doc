# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
class RailsApiDoc::Controller::Parameter::Param

  ACCEPTED_TYPES = [String, Integer, Object, Array, :enum].freeze

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
    return unless type == Object && !block_given
    raise ArgumentError, 'Empty object passed.'
  end

  def initialize
    @store = {}
  end

  def nested?
    @store[:type] == Object
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
