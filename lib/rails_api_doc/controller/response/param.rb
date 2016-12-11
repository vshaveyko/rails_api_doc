# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
module RailsApiDoc
  module Controller
    module Response

      #
      # name - attribute key returned in json response
      # attr - actual attribute usage attribute
      # nested - attribute nesting if present
      # model - attribute model if nested and has model
      # desc - description for attribute
      # type - attribute type if set
      # id - param id in DB for lookup on display
      #
      class Param < RailsApiDoc::Controller::Param

        define_accessors *VALID_RESPONSE_KEYS

        def initialize(name, attr, nested, model = nil, desc = nil, type = nil, id = nil, action_type = nil, is_new: false)
          @name = name
          @store = {
            name: name,
            attr: attr,
            nested: nested,
            model: model,
            desc: desc,
            type: type,
            action_type: action_type,
            id: id
          }.compact

          @is_new = is_new
          @new = []
        end

        def nested?
          !nested.nil?
        end

        def display_value
          title = attr.to_s
          title += '(NESTED)' if nested?
          title
        end

      end
    end
  end
end
