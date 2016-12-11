# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
module RailsApiDoc
  module Controller
    class Param

      COMMON_VALID_KEYS = [:type, :model, :desc, :id, :nested, :action_type].freeze #:nodoc:
      VALID_REQUEST_KEYS = [:required, :enum, :value].freeze
      VALID_RESPONSE_KEYS = [:attr].freeze
      VALID_KEYS = (COMMON_VALID_KEYS + VALID_REQUEST_KEYS + VALID_RESPONSE_KEYS).freeze

      HELPER_KEYS = [:new, :is_new, :param, :name].freeze
      attr_accessor *HELPER_KEYS

      #
      # define methods responding to each type with '?'
      # ex: ary_object? array? string?
      #
      RailsApiDoc::ACCEPTED_TYPES.each do |type|
        define_method "#{type}?" do
          @store[:type] == type.to_sym
        end
      end

      #
      # redirect all keys accssors to store
      # .type= is @store[:type]=
      # .type  is @store[:type]
      #
      def self.define_accessors(*accessors)
        accessors.each do |acc|
          define_method acc do
            @store[acc]
          end

          define_method "#{acc}?" do
            @store[acc].present?
          end

          define_method "#{acc}=" do |val|
            @store[acc] = val
          end
        end
      end

      #
      # define methods for each store key
      # type, name, etc
      #
      define_accessors *COMMON_VALID_KEYS

      #
      # try sending other methods to @store
      # if possible
      #
      delegate :[], :[]=, :each_value, to: :@store

      #
      # these are actions applied to the params by gem user from frontend
      #
      def destroyed?
        action_type == 'destroy'
      end

      def created?
        action_type == 'create'
      end

      def updated?
        action_type == 'update'
      end

      def add_updated_field(field)
        @new.push(field) unless field.in?(@new)
      end

      #
      # redefine to get desired behaviour
      #
      def display_type
        t = if nested?
              (model || type).to_s + '(Nested)'
            else
              type.to_s
            end

        t += "(#{param.type})" if param && param.type != type

        t
      end

      #
      # redefined in descendants
      #
      def display_special
      end

      #
      # redefined in descendants
      #
      def display_name
        @name
      end

      #
      # redefined in descendants
      #
      def display_value
      end

    end
  end
end
