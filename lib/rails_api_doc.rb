# author: Vadim Shaveiko <@vshaveyko>
# frozen_string_literal: true
module RailsApiDoc
  NESTED_TYPES = [:ary_object, :object, :json].freeze

  STRAIGHT_TYPES = [:bool, :string, :integer, :array, :datetime, :enum, :model].freeze

  ACCEPTED_TYPES = (NESTED_TYPES + STRAIGHT_TYPES).freeze

  module Controller
    _dir = 'rails_api_doc/controller/'

    autoload :Repo, _dir + 'repo'
    autoload :Param, _dir + 'param'
    autoload :Headers, _dir + 'headers'

    module Response
      _dir = 'rails_api_doc/controller/response/'

      autoload :Factory, _dir + 'factory'
      autoload :Headers, _dir + 'headers'
      autoload :Param, _dir + 'param'
      autoload :Repository, _dir + 'repository'
    end

    module Request
      _dir = 'rails_api_doc/controller/request/'

      autoload :DSL, _dir + 'dsl'
      autoload :Factory, _dir + 'factory'
      autoload :Param, _dir + 'param'
      autoload :Headers, _dir + 'headers'
      autoload :Repository, _dir + 'repository'
    end

    module ResourceParams
      _dir = 'rails_api_doc/controller/strong_params/'

      autoload :DSL, _dir + 'dsl'
      autoload :PermittedParams, _dir + 'permitted_params'
    end
  end

  module Model
    _dir = 'rails_api_doc/model/'

    autoload :AttributeMerger, _dir + 'attribute_merger'
    autoload :AttributeParser, _dir + 'attribute_parser'
  end

  require 'rails_api_doc/config'
  class Config

    _dir = 'rails_api_doc/config/'

    autoload :Validator, _dir + 'validator'
    autoload :ValidateEnum, _dir + 'validate_enum'
    autoload :ValidateType, _dir + 'validate_type'
    autoload :ValidateAryObject, _dir + 'validate_ary_object'

  end

  module Exception
    _dir = 'rails_api_doc/exception/'

    autoload :ParamRequired, _dir + 'param_required'
  end

  class << self

    def configure
      yield configuration
    end

    def configuration
      @_configuration ||= Config.new
    end

    def reset_configuration
      @_configuration = nil
    end

  end

end

require 'rails_api_doc/version'
require 'rails_api_doc/engine'
