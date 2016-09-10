# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
class RailsApiDoc::Config::Validator

  cattr_accessor :checkers
  self.checkers = []

  def self.valid_param?(controller_param, api_param_data)
    checkers.all? do |checker|
      checker.valid?(controller_param, api_param_data)
    end
  end

end
