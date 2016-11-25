# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
require 'rails_helper'

service = RailsApiDoc::Controller::AttributeParser
describe service do
  it 'parses numbers correctlyu' do
    given = {
      enum: '1,2,3',
      type: 'Who+cares'
    }

    expected = {
      type: :enum,
      enum: [1, 2, 3]
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'parses words' do
    given = {
      enum: 'EnumValue',
      type: ''
    }

    expected = {
      enum: ['EnumValue'],
      type: :enum
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'parses commaseparated values' do
    given = {
      enum: '23enum1, 34enum2'
    }

    expected = {
      type: :enum,
      enum: ['23enum1', ' 34enum2']
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'correctly parses enum array of string attributes' do
    given = {
      enum: "['enum1','enum2']"
    }

    expected = {
      type: :enum,
      enum: %w(enum1 enum2)
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'correctly parses camelcased names attributes' do
    given = {
      name: 'CamelCasedName',
      type: 'String'
    }

    expected = {
      name: :camel_cased_name,
      type: String
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'correctly parses types when correct classes are given' do
    # [String, Integer, Object, Array, DateTime,
    correct_classses = {
      'String' => String,
      'Integer' => Integer,
      'Object' => Object,
      'Array' => Array,
      'Bool' => Bool,
      'DateTime' => DateTime
    }.each do |correct_class_name, correct_class|
      given = {
        type: correct_class_name
      }

      expected = {
        type: correct_class
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
end
