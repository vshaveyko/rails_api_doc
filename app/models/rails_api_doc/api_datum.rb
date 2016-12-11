# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::ApiDatum < ActiveRecord::Base

  #
  # integer :api_type - request | response
  #
  # string :api_action - create | show | edit | ...
  # string :action_type - destroy | update | create
  # string :type - param data type
  # string :name - param name
  # string :special - special param data
  # string :desc - description
  #
  # text :nesting - model nesting to display
  #

  self.inheritance_column = ''

  serialize :nesting, Array

  enum api_type: [:request, :response]

end
