# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::ApiDatum < ActiveRecord::Base

  serialize :nesting, Array

end
