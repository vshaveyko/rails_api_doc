# :nodoc:
class RailsApiDoc::Controller::Response::Rabl

  attr_reader :map

  # pass all controllers registered for api doc
  # TODO: add setting for displaying all from scratch
  def initialize(controllers)
    @controllers = controllers
    @map = construct_controller_template_map
  end

  def construct_controller_template_map
    @controllers.inject({}) do |map, ctrl|
      map[ctrl] = load_templates(ctrl)
    end
  end

  private

    # load all rabl templates from app/views/ctrl_name/ .rabl
    def load_templates(ctrl)
      Dir.glob("app/views/#{ctrl.controller_path}/**/*.rabl")
    end

end
