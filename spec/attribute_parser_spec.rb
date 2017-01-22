# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
require 'rails_helper'

service = RailsApiDoc::Model::AttributeParser
describe service do
  it 'parses numbers correctlyu' do
    given = {
      nesting: ['value'],
      special: '1,2,3',
      action: 'action',
      api_action: 'show',
      type: 'enum',
      id: 5,
      desc: 'enum value'
    }

    expected = {
      type: :enum,
      nesting: ['value'],
      action_type: 'action',
      api_action: 'show',
      special: [1, 2, 3],
      id: 5,
      desc: 'enum value'
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'parses words' do
    given = {
      special: 'EnumValue',
      type: 'enum'
    }

    expected = {
      special: ['EnumValue'],
      type: :enum
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'correctly parses camelcased names attributes' do
    given = {
      name: 'CamelCasedName',
      type: 'string'
    }

    expected = {
      name: :camel_cased_name,
      type: :string
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'correctly parses types when correct classes are given' do
    # [String, Integer, Object, Array, DateTime,
    correct_classses = %w(string bool integer datetime object ary_object)
    correct_classses.each do |correct_class_name|
      given = {
        type: correct_class_name
      }

      expected = {
        type: correct_class_name.to_sym
      }

      expect(service.parse_attributes(given)).to eq expected
    end
  end

  it 'raises exception if incorrect class signature given' do
    given = {
      type: 'WrongClass'
    }

    expect { service.parse_attributes(given) }.to raise_error NameError

    given = {
      type: 'Wr+-/asCl'
    }

    expect { service.parse_attributes(given) }.to raise_error NameError
  end

  it 'parses special of object type' do
    given = {
      special: 'Author',
      type: :object
    }

    expected = {
      special: 'Author',
      type: :object
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'parses special of ary_object' do
    given = {
      special: 'Author',
      type: :ary_object
    }

    expected = {
      special: 'Author',
      type: :ary_object
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'skips special if it is not used by type' do
    given = {
      special: 'Author',
      type: :datetime
    }

    expected = {
      type: :datetime
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'skips special if it is not used by type integer' do
    given = {
      special: 'Author',
      type: :integer,
      api_type: 'request'
    }

    expected = {
      type: :integer,
      api_type: 'request'
    }

    expect(service.parse_attributes(given)).to eq expected
  end
end
