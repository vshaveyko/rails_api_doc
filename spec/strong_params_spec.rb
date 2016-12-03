# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
require 'rails_helper'

describe RailsApiDoc::Controller::ResourceParams, type: :controller do
  # RailsApiDoc.configure do |config|
  # config.check_params_type = false
  # end

  describe ApplicationController do
    controller do
      parameter :name, type: String, required: true

      parameter :age, type: Integer

      parameter :is_married, type: :bool

      parameter :children_attributes, type: :ary_object do
        parameter :age
        parameter :name
      end

      parameter :wife_attributes, type: :object do
        parameter :age
        parameter :name
      end

      def index
        render json: resource_params
      end
    end

    def json_resp
      JSON.parse response.body
    end

    describe :resource_params do
      it 'filters redundant parameters' do
        given = {
          name: 'James',
          age: '27',
          sibling: true,
          is_married: true
        }

        expected = { 'name' => 'James', 'age' => '27', 'is_married' => 'true' }

        get :index, params: given

        expect(json_resp).to eq expected
      end

      it 'filters redundant parameters in nested objects' do
        given = {
          name: 'James',
          wife_attributes: { name: 'Joan', age: '25', cheating: true }
        }

        expected = {
          'name' => 'James',
          'wife_attributes' => { 'name' => 'Joan', 'age' => '25' }
        }

        get :index, params: given

        expect(json_resp).to eq expected
      end

      it 'accepts only array of objects to type ary_object' do
        given = {
          name: 'James',
          children_attributes: { name: 'Jim', age: '5' }
        }

        expected = {
          'name' => 'James'
        }

        get :index, params: given

        expect(json_resp).to eq expected
      end

      it 'parses array of objects on type ary_object' do
        given = {
          name: 'James',
          children_attributes: [{ name: 'Jim', age: '5' }]
        }

        get :index, params: given

        expect(json_resp).to eq given.deep_stringify_keys
      end

      it 'raises if required parameter is not present(returns status 500)' do
        given = {}

        expect { get :index, params: given }.to raise_error RailsApiDoc::Exception::ParamRequired
      end
      #
      # RailsApiDoc.configure do |config|
      # config.check_params_type = true
      # end
      #
      # it 'skips parameter if type does not match' do
      # given = {
      # name: '27',
      # age: 'James',
      # wife_attributes: {
      # name: 'Joan',
      # age: 'error'
      # },
      # children_attributes: [5, 'Jim']
      # }
      #
      # expected = {
      # wife_attributes: { name: 'Joan' }
      # }
      #
      # get :index, params: given
      #
      # expect(json_resp).to eq expected
      # end
    end
  end
end
