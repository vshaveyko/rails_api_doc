# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Config::ValidateType

  #
  # @api_param_data - RailsApiDoc::Controller::Parameter::Repository::Param
  # @controller_param - ActionController::Parameter
  #
  # check validation of current type by given data
  #
  # type: check that param value is of requested type
  # Examples:
  #
  #   1. controller_param == '1'                                                , api_param_data[:type] == :integer                                  > ok
  #   2. controller_param == 'string'                                           , api_param_data[:type] == :integer                                  > not_ok
  #   3. controller_param == {a: 'b'}                                           , api_param_data[:type] == :object                                   > ok
  #   4. controller_param == [{a:'b'}, {c: 'd'}]                                , api_param_data[:type] == :ary_object                               > ok
  #   5. controller_param == "2016-11-26 13:55:30 +0200"(or any other singature , use DateTime.parse to check) , api_param_data[:type] == :datetime  > ok
  #   6. controller_param == 'true'                                             , api_param_data[:type] == :bool                                     > ok
  #   7. controller_param == true                                               , api_param_data[:type] == :bool                                     > ok
  #   8. controller_param == 'ok'                                               , api_param_data[:type] == :bool                                     > not_ok
  #   9. controller_param == ['1', '2', 3]                                      , api_param_data[:type] == :array                                    > ok
  #  10. controller_param == [{a:'b'}]                                          , api_param_data[:type] == :array                                    > not_ok
  #
  # TODO: write rspec for this cases and implement
  def valid?(_controller_param, _api_param_data)
    true
  end

end
