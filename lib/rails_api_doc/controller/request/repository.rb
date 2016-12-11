# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Request::Repository

  include RailsApiDoc::Controller::Request::Headers
  extend RailsApiDoc::Controller::Repo
  include RailsApiDoc::Controller::Repo

  def initialize
    @repo = self.class.repo.clone.transform_values { |v| v.deep_dup }
  end

end
