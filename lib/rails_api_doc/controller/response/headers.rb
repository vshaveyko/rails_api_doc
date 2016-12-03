# :nodoc:
module RailsApiDoc::Controller::Response::Headers

  RESPONSE_HEADERS = {
    'Parameter' => {
      value: -> (row_name, row_values) { row_name },
      fill_type: :input,
      param: :name
    },
    'Value' => {
      value: -> (row_name, row_values) {
        title = row_values.attr.to_s
        title += '(NESTED)' if row_values.nested?
        title
      }
    }
  }

  def headers
    RESPONSE_HEADERS
  end

end
