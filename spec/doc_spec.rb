require 'rails_helper'
describe RailsApiDoc do
  TestsController = Class.new(ActionController::Base)

  Rails.application.routes.draw do
    resources :tests
  end

  Rails.application.reload_routes!

  describe TestsController, type: :controller do

    describe 'when defined parameter in controller' do

      it 'is added to repository' do
        TestsController.parameter :param, type: String
        parameters = RailsApiDoc::Controller::Parameter::Repository[TestsController]
        expect(parameters[:param]).to eq type: String
      end

      it 'correctly adds nesting' do
        TestsController.parameter(:nested_param, type: Object) do
          TestsController.parameter(:param, type: String)
          TestsController.parameter(:enum_param, type: :enum, enum: [1, 2])
        end

        parameters = RailsApiDoc::Controller::Parameter::Repository[TestsController]

        expected = {
          type: Object,
          nested: {
            param: { type: String },
            enum_param: { type: :enum, enum: [1, 2] },
          }
        }

        expect(parameters[:nested_param]).to eq expected
      end

      it 'filters params with strong_params with correct params' do
        controller.params[:param] = 'param'
        controller.params[:nested_param] = { param: 'param', enum_param: 1, wrong_param: 3 }

        params = {}

        expect(controller.resource_params).to eq controller.params.permit(:param, nested_param: [:param, :enum_param])
      end
    end
  end

end
