# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Request::Repository

  include RailsApiDoc::Controller::Request::Headers
  extend RailsApiDoc::Controller::Repo
  include RailsApiDoc::Controller::Repo

  def self.params_for_klass(klass)
    params = {}

    while klass != ActionController::Base
      params.merge!(self[klass])
      klass = klass.superclass
    end

    params
  end

  def initialize
    @repo = self.class.repo.clone.transform_values(&:deep_dup)
  end

end
