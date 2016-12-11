# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
class RailsApiDoc::Model::AttributeMerger

  MODEL = RailsApiDoc::ApiDatum
  MERGABLE_FIELDS = [:type, :desc, :action_type].freeze

  #
  # do not mutate attributes
  #
  # please - impossible
  #
  def initialize(attributes)
    @attrs = attributes
  end

  def call(api_type:)
    @api_type = api_type

    api_params = MODEL.where(api_type: api_type).all.each do |param|
      _add_nested_param(param)
    end

    @attrs
  end

  private

  def _add_nested_param(param)
    # nesting should be present for parameter to appear
    return if param.nesting.blank?

    attrs, nesting, name = _parse_settings(param)

    return unless name

    ctrl_param = _find_param(nesting, name, attrs)

    ctrl_param.param = param
    # _merge_data_to_param(ctrl_param, param)
  end

  def _parse_settings(param)
    ctrl = param.nesting[0].constantize
    nesting = param.nesting[1..-1]
    name = param.name&.to_sym
    attrs = @attrs[ctrl]

    #
    # making exception
    # until request parameters are not split by actions
    #
    attrs = attrs[param.api_action] if @api_type == 'response'

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

  def _find_param(nesting, name, attrs)
    nesting.each do |model|
      nested_attrs = attrs.each_value.detect { |v| v.nested? && v.model == model }

      attrs = nested_attrs ? nested_attrs : _define_nesting_level(attrs, name, model)
    end

    if attrs[name]
      attrs[name]
    else
      attrs[name] = _init_param_for_api_type(name)
    end
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
      RailsApiDoc::Controller::Response::Param.new(name, name, options[:nested], options[:model], '', options[:type], is_new: true)
    end
  end

end
