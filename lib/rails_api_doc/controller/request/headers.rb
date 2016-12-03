# :nodoc:
module RailsApiDoc
  module Controller
    module Request
      module Headers

        def headers
          REQUEST_HEADERS
        end

        REQUEST_HEADERS = {
          'Parameter' => {
            value: -> (row_name, row_values) {
              title = row_name.to_s
              title += '*' if row_values.required?
              title
            },
            fill_type: :input,
            param: :name
          },
          'Type' => {
            value: -> (row_name, row_values) {
              if row_values.nested?
                (row_values.model || row_values.type).to_s + "(Nested)"
              else
                row_values.type
              end
            },
            fill_type: :select,
            param: :type,
            values: RailsApiDoc::Controller::Request::Param::ACCEPTED_TYPES
          },
          'Special' => {
            value: -> (row_name, row_values) {
              case
              when row_values.enum?
                row_values[:enum]
              when row_values.model?
                row_values[:model]
              end
            },
            fill_type: :input,
            param: :special
          },
          'Desc' => {
            value: -> (row_name, row_values) {
              'TODO: description' # if row_values[:desc]
            },
            fill_type: :input,
            param: :desc
          }
        }
      end
    end
  end
end
