# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
require 'rails_helper'

RSpec.describe RailsApiDoc do
  TestCtrl = Class.new(ActionController::Base)

  class TestParameter < RailsApiDoc::Params

    parameter :name, type: :string

  end

  describe 'Parameter guess' do
    it 'Can guess parameter class by controller name' do
      ctrl = TestCtrl.new

      expect(ctrl).to respond_to :ctrl_strong_params

      expect(ctrl.ctrl_parameters).to be_a_kind_of(TestParameter)
    end

    it 'Will return correct strong params from ctrl_strong_params' do
      ctrl = TestCtrl.new

      expect(ctrl.ctrl_strong_params.first).to eq(:name)
    end
  end

  describe 'Parameter class change' do
    class NewTestParameter < RailsApiDoc::Params

      parameter :age, type: :integer

    end

    it 'Returns ctrl parameters correctly' do
      TestCtrl.parameter_class = NewTestParameter

      ctrl = TestCtrl.new

      expect(ctrl.ctrl_parameters).to be_a_kind_of(NewTestParameter)
    end

    it 'Returns correct strong params' do
      TestCtrl.parameter_class = NewTestParameter

      ctrl = TestCtrl.new

      expect(ctrl.ctrl_strong_params.first).to eq(:age)
    end
  end
end
