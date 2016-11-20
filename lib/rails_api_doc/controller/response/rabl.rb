# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
# :nodoc:
class RailsApiDoc::Controller::Response

  # :nodoc:
  class Rabl

    class << self

      attr_accessor :renderer

    end

    attr_reader :map

    # pass all controllers registered for api doc
    # TODO: add setting for displaying all from start
    def initialize(controllers)
      @controllers = controllers
      @routes = Rails.application.routes.set.anchored_routes.reject { |r| r.defaults[:internal] }
      @map = construct_controller_template_map
    end

    def load_template(ctrl, action)
      RablCompiler.new("#{ctrl.controller_path}/#{action}").compile_source
    end

    def action_route(ctrl, action)
      action_route = @map[ctrl][:routes].detect { |r| r.defaults[:action] == action }
      method = action_route.instance_variable_get(:@request_method_match).first.name.split('::').last
      route = action_route.path.spec.to_s
      [method, route].join(' ')
    end

    private

    def construct_controller_template_map
      @controllers.each_with_object({}) do |ctrl, map|
        map[ctrl] = ctrl_actions(ctrl)
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
