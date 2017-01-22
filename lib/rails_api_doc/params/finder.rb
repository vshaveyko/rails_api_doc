# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Params::Finder

  SUFFIX = 'Parameter'

  def initialize(object)
    @object = object
  end

  def call
    klass = find_class_name(@object).name.sub(/Ctrl$/, '')

    "#{klass}#{SUFFIX}".constantize
  end

  private

  def find_class_name(subject)
    if subject.respond_to?(:model_name)
      subject.model_name
    elsif subject.class.respond_to?(:model_name)
      subject.class.model_name
    elsif subject.is_a?(Class)
      subject
    elsif subject.is_a?(Symbol)
      subject.to_s.camelize
    else
      subject.class
    end
  end

end
