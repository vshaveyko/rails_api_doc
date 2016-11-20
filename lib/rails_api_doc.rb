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

require 'rails_api_doc/engine'
