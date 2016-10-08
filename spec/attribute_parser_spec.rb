require 'spec_helper'

service = RailsApiDoc::Controller::AttributeParser
describe service do

  it 'correctly parses enum array attributes' do
    given = {
      enum: '[1,2,3]',
      type: 'Who+cares'
    }

    expected = {
      type: :enum,
      enum: [1,2,3]
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'raises if not array passed' do
    given = {
      enum: "WrongEnumValue"
    }

    expect(service.parse_attributes(given)).to raise_error ArgumentError
  end

  it 'deletes everything after number if array passed is numberlike' do
    given = {
      enum: "[23enum1, 34enum2]"
    }

    expected = {
      type: :enum,
      enum: [23, 34]
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'correctly parses enum array of string attributes passed without quotes' do
    given = {
      enum: "[enum1, enum2]"
    }

    expected = {
      type: :enum,
      enum: ['enum1', 'enum2']
    }

    expect(service.parse_attributes(given)).to eq expected
  end

  it 'correctly parses enum array of string attributes' do
    given = {
      enum: "['enum1', 'enum2']"
    }

    expected = {
      type: :enum,
      enum: ['enum1', 'enum2']
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
      'DateTime' => DateTime
    }

    correct_classes.each do |correct_class_name, correct_class|

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

    expect(service.parse_attributes(given)).to raise_error ArgumentError

    given = {
      type: 'Wr+-/asCl'
    }

    expect(service.parse_attributes(given)).to raise_error ArgumentError
  end

end
