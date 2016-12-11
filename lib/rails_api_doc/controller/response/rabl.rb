# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
# :nodoc:
module RailsApiDoc::Controller::Response

  # :nodoc:
  class Rabl

    class << self

      attr_accessor :renderer

    end

    attr_reader :repo

    # pass all controllers registered for api doc
    # TODO: add setting for displaying all from start
    def initialize(controllers)
      @controllers = controllers

      @routes = Rails.application.routes.set.anchored_routes.reject { |r| r.defaults[:internal] }

      @repo = construct_controller_template_map
    end

    def construct_controller_template_map
      @controllers.each_with_object({}) do |ctrl, repo|
        repo[ctrl] = ctrl_actions(ctrl)
      end
    end

    private

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
