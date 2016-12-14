# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Controller::Response::Repository

  include RailsApiDoc::Controller::Repo
  include RailsApiDoc::Controller::Response::Headers

  def initialize(repo)
    @repo = repo.clone.transform_values(&:deep_dup)
  end

  def load_attrs(ctrl, action)
    at = load_template(ctrl, action)&.nodes || {}

    at = RailsApiDoc::Model::AttributeMerger.new(at, 'response').merge_action(action: action, ctrl: ctrl)

    at
  end

  def load_template(ctrl, action)
    RailsApiDoc::Controller::Response::RablCompiler.new("#{ctrl.controller_path}/#{action}").compile_source
  end

  def action_route(ctrl, action)
    return unless action_route = action_route_for(ctrl, action)

    {
      method: method(action_route),
      url: url(action_route)
    }
  end

  private

  def method(route)
    route.instance_variable_get(:@request_method_match)&.first&.name&.split('::')&.last
  end

  def url(a_route)
    a_route.path.spec.to_s.gsub(/(\(.*\))/, '')
  end

  def action_route_for(ctrl, action)
    @repo[ctrl][:routes].detect { |r| r.defaults[:action] == action }
  end

end
