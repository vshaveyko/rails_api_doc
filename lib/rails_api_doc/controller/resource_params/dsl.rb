# :nodoc:
module RailsApiDoc
  module Controller
    module ResourceParams
      module DSL

        include RailsApiDoc::Controller::ResourceParams::PermittedParams # implements params_to_permit

        def resource_params
          # accepted_params for permit
          params.permit(params_to_permit)
        end

      end
    end
  end
end
