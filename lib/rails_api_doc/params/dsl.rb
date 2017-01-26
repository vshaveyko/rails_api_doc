# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
module RailsApiDoc::Params::DSL

  def self.included(base)
    base.extend ClassMethods
  end

  #:nodoc:
  module ClassMethods
    def parameter_class=(value)
      @parameter_class = value
    end

    def parameter_class
      @parameter_class ||= RailsApiDoc::Params::Finder.new(self).call
    end
  end

  def ctrl_strong_params(p = params)
    @ctrl_strong_params ||= strong_params(p, params_holder: ctrl_parameters)
  end

  def ctrl_parameters
    @ctrl_parameters ||= self.class.parameter_class
  end

end
