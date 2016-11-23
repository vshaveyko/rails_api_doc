# author: Vadim Shaveiko <@vshaveyko>
# frozen_string_literal: true
module RailsApiDoc

  extend ActiveSupport::Autoload

  class << self

    def configure
      yield configuration
    end

    def configuration
      @_configuration ||= Configuration.new
    end

    def reset_configuration
      @_configuration = nil
    end

  end

  autoload :Controller

end

# constants for defining in controllers
# TODO: move to namespace ?
class Bool
end

class Enum
end

class Nested
end

require 'rails_api_doc/version'
require 'rails_api_doc/engine'
