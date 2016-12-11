# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
module RailsApiDoc
  module Controller
    module Request
      module Headers

        include RailsApiDoc::Controller::Headers

        def headers
          REQUEST_HEADERS
        end

        REQUEST_HEADERS = [
          NAME_HEADER,
          TYPE_HEADER,
          SPECIAL_HEADER,
          DESC_HEADER
        ].reduce(&:merge).freeze

      end
    end
  end
end
