# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
require 'spec_helper'

RSpec.describe do
  TestCtrl = Class.new(ActionController::Base)

  it 'behaves' do
    param = ActionController::Parameters.new(name: 'name')
    ctrl = TestCtrl.new

    expect { ctrl.strong_params(param) }.not_to raise_error NoMethodError
  end
end
