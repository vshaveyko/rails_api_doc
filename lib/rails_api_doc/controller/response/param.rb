# :nodoc:
module RailsApiDoc
  module Controller
    module Response
      class Param < Struct.new(:name, :attr, :nested, :model, :desc)

        def nested?
          !nested.nil?
        end

      end
    end
  end
end
