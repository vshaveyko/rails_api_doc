# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
module RailsApiDoc
  module Exception
    class ParamRequired < StandardError

      def initialize(param_name)
        @message = "#{param_name} is marked as required, but has no value."
      end

    end
  end
end
