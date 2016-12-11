# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
module RailsApiDoc
  module Controller
    module Request
      class Param < RailsApiDoc::Controller::Param

        #
        # define methods for each store key
        # type, name, etc
        #
        define_accessors *VALID_REQUEST_KEYS

        #
        # @type - type to check
        #
        def self.accepted_nested_type?(type)
          type.in?(RailsApiDoc::NESTED_TYPES)
        end

        def self.valid_type?(type)
          return if type.nil? || type.in?(RailsApiDoc::ACCEPTED_TYPES)
          raise ArgumentError, "Wrong type: #{type}. " \
                               "Correct types are: #{RailsApiDoc::ACCEPTED_TYPES}."
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

        def initialize(name, store, is_new: false)
          @name = name
          @store = store

          @new = []
          @is_new = is_new
        end

        def nested?
          self.class.accepted_nested_type?(@store[:type])
        end

        def display_special
          spec = if enum?
                  enum
                elsif model?
                  model
                end

          spec || param&.special
        end

        def display_name
          title = @name.to_s

          title += '*' if required?

          title
        end

      end
    end
  end
end
