# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
module RailsApiDoc::Controller::Response::Headers

  include RailsApiDoc::Controller::Headers

  RESPONSE_HEADERS = [
    NAME_HEADER,
    TYPE_HEADER,
    VALUE_HEADER,
    DESC_HEADER
  ].reduce(&:merge).freeze

  def headers
    RESPONSE_HEADERS
  end

end
