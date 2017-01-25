# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
require 'rails_helper'

RSpec.describe RailsApiDoc::Controller::Request::Repository do
  class TestCtrlBase < ActionController::Base

    parameter :name, type: :string

  end

  TestCtrlInherited = Class.new(TestCtrlBase)

  it 'gathers all params through inhertiance chain' do
    gathered_params = RailsApiDoc::Controller::Request::Repository.params_for_klass(TestCtrlInherited)

    expect(gathered_params).to have_key :name
  end
end
