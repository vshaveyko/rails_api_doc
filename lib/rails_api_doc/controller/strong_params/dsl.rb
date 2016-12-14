# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
module RailsApiDoc
  module Controller
    module ResourceParams
      module DSL # :nodoc:

        include RailsApiDoc::Controller::ResourceParams::PermittedParams # implements params_to_permit

        def strong_params(pars = params)
          #
          # accepted_params for permit
          #
          pars.permit(params_to_permit)
        end

      end
    end
  end
end
