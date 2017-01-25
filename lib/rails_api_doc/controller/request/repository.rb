# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Request::Repository

  include RailsApiDoc::Controller::Request::Headers

  extend RailsApiDoc::Controller::Repo
  include RailsApiDoc::Controller::Repo

  class << self

    def params_for_klass(klass)
      params = {}

      until _abstract_class(klass)
        params.merge!(self[klass])
        klass = klass.superclass
      end

      params
    end

    def _abstract_class(klass)
      klass == ActionController::Base || klass == RailsApiDoc::Params
    end

  end

  def initialize
    @repo = self.class.repo.clone.transform_values(&:deep_dup)
  end

end
