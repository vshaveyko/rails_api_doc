# author: Vadim Shaveiko <@vshaveyko>
# frozen_string_literal: true
require 'rails_api_doc/config'

module RailsApiDoc

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

end

require 'rails_api_doc/version'
require 'rails_api_doc/engine'
