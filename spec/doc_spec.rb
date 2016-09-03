require 'spec_helper'

describe RspecApiDoc do
  describe 'when defined parameter in controller' do
    it 'is added to repository' do
      ApplicationController.parameter :param, type: String
      parameters = RailsApiDoc::Controller::Parameter::Repository[ApplicationController]
      expect(parameters[:param]).to eq type: String
    end
  end
end
