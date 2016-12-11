module RailsApiDoc
  module ApplicationHelper

    def construct_destroy_param(row_values, init_params, nesting)
      [
        init_params,
        row_values.store,
        nesting: nesting,
        id: row_values.param&.id,
        name: row_values.name
      ].reduce(&:merge)
    end

  end
end
