# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
# :nodoc:
module RailsApiDoc::Controller::Response

  # :nodoc:
  class Rabl

    include RailsApiDoc::Controller::Response::Headers
    include RailsApiDoc::Controller::Repo

    class << self

      attr_accessor :renderer

    end

    # pass all controllers registered for api doc
    # TODO: add setting for displaying all from start
    def initialize(controllers)
      @controllers = controllers
      @routes = Rails.application.routes.set.anchored_routes.reject { |r| r.defaults[:internal] }
      @repo = construct_controller_template_map
    end

    def load_template(ctrl, action)
      RablCompiler.new("#{ctrl.controller_path}/#{action}").compile_source
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

    def construct_controller_template_map
      @controllers.each_with_object({}) do |ctrl, repo|
        repo[ctrl] = ctrl_actions(ctrl)
      end
    end

    def ctrl_actions(ctrl)
      routes = @routes.select do |route|
        route.defaults[:controller].in?([ctrl.controller_path, ctrl.controller_name])
      end
      actions = routes.map { |r| r.defaults[:action] }
      {
        routes: routes,
        actions: ctrl.action_methods
      }
    end

  end

end
