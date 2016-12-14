# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Model::AttributeMerger

  MODEL = RailsApiDoc::ApiDatum
  MERGABLE_FIELDS = [:type, :desc, :action_type].freeze

  @@data = MODEL.all

  #
  # do not mutate attributes
  #
  # please - impossible
  #
  def initialize(attributes, api_type)
    @attrs = attributes.stringify_keys
    @api_type = api_type
  end

  def merge_action(action:, ctrl:)
    merge_data = @@data.select { |d| d.api_type == @api_type && d.api_action == action.to_s && d.nesting.first == ctrl.name }

    merge_data.each do |param|
      _add_nested_param(param, param.nesting[1..-1], @attrs)
    end

    @attrs
  end

  def call
    api_params = @@data.select { |d| d.api_type == @api_type }.each do |param|
      #
      # nesting should be present for parameter to appear
      #
      next unless param.name && param.nesting.present?

      attrs, nesting, name = _parse_settings(param)

      _add_nested_param(param, nesting, attrs)
    end

    @attrs
  end

  private

  def _add_nested_param(param, nesting, attrs)
    ctrl_param = _find_param(nesting, param.name, attrs)

    ctrl_param.param = param
    # _merge_data_to_param(ctrl_param, param)
  end

  def _parse_settings(param)
    ctrl = param.nesting[0]
    nesting = param.nesting[1..-1]
    name = param.name&.to_sym
    attrs = @attrs[ctrl]

    [attrs, nesting, name]
  end

  def _merge_data_to_param(ctrl_param, param)
    MERGABLE_FIELDS.each do |field|
      next if ctrl_param_value = ctrl_param.public_send(field) # do not override data set in api ctrl

      param_value = param.public_send(field)
      next if param_value.blank?

      ctrl_param.public_send("#{field}=", param_value)
      ctrl_param.add_updated_field(field)
    end

    _merge_special(ctrl_param, param)
  end

  def _merge_special(ctrl_param, param)
    return if param.special.blank?

    if ctrl_param.enum? && ctrl_param.enum.blank?
      ctrl_param.enum = _parse_enum(param.special)
      ctrl_param.add_updated_field('enum')
    elsif ctrl_param.nested? && ctrl_param.model.blank?
      ctrl_param.model = special.capitalize
      ctrl_param.add_updated_field('model')
    end
  end

  def _find_param(nest, name, attrs)
    nest.each do |model|
      #
      # model on different fields because of wrong nesting sturcture for request
      # TODO: fix this later
      #
      nested_attrs = attrs.detect { |k, v| v.nested? && (v.model == model || k.to_s == model)  }

      attrs = nested_attrs ? nested_attrs : _define_nesting_level(attrs, name, model)
    end

    attrs[name] ||= _init_param_for_api_type(name, {})
  end

  def _define_nesting_level(attrs, name, model)
    attr = _init_param_for_api_type(name, type: :object, model: model, nested: {})

    attrs[name] = attr
  end

  #
  # common attrs:
  # 1. name
  # 2. type
  # 3. desc
  # 4. model
  # 5. id
  # 6. nested
  #
  # request attrs:
  # 1. enum
  # 2. value
  # 3. required
  #
  # response attrs:
  # 1. attr
  #
  def _init_param_for_api_type(name, options)
    if @api_type == 'request'
      RailsApiDoc::Controller::Request::Param.new(name, options, is_new: true)
    elsif @api_type == 'response'
      RailsApiDoc::Controller::Response::Param.new(name, name, options[:nested], options[:model], nil, options[:type], is_new: true)
    end
  end

end
