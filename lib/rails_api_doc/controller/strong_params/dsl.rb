# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
module RailsApiDoc
  module Controller
    module ResourceParams
      module DSL

        include RailsApiDoc::Controller::ResourceParams::PermittedParams # implements params_to_permit

        def resource_params(pars = params)
          #
          # accepted_params for permit
          #
          pars.permit(params_to_permit)
        end

      end
    end
  end
end
