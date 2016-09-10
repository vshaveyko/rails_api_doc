# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Parameter::Repository

  @repo = Hash.new { |hsh, key| hsh[key] = Param.new }

  class << self

    def method_missing(name, *args)
      return @repo.send(name, *args) if respond_to_missing?(name)
      super
    end

    def respond_to_missing?(method)
      @repo.respond_to?(method)
    end

    def []=(key, value)
      unless key < ActionController::Base
        raise ArgumentError, 'Repository keys are controllers only'
      end

      super
    end

  end

end
