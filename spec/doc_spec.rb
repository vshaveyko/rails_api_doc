# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
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
        TestsController.parameter :param, type: :string
        parameters = RailsApiDoc::Controller::Request::Repository[TestsController]
        expect(parameters[:param].store).to eq type: :string
      end

      it 'correctly adds nesting' do
        TestsController.parameter(:nested_param, type: :object) do
          TestsController.parameter(:param, type: :string)
          TestsController.parameter(:enum_param, type: :enum, enum: [1, 2])
        end

        parameters = RailsApiDoc::Controller::Request::Repository[TestsController]

        expected = {
          type: :object,
          nested: {
            param: { type: :string },
            enum_param: { type: :enum, enum: [1, 2] }
          }
        }

        nested = parameters[:nested_param]

        expect(nested[:type]).to eq expected[:type]

        nested = parameters[:nested_param].store[:nested]
        expect(nested[:param].store).to eq expected[:nested][:param]
        expect(nested[:enum_param].store).to eq expected[:nested][:enum_param]
      end

      it 'filters params with strong_params with correct params' do
        controller.params[:param] = 'param'
        controller.params[:nested_param] = { param: 'param', enum_param: 1, wrong_param: 3 }

        expect(controller.strong_params).to eq controller.params.permit(:param, nested_param: [:param, :enum_param])
      end
    end
  end
end
