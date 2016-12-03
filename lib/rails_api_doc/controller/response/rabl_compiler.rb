# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
# :nodoc:
class RailsApiDoc::Controller::Response

  class Node < Struct.new(:name, :attr, :nested, :model)

    def nested?
      !nested.nil?
    end

  end

  # template struct
  class CompiledAttributes

    attr_accessor :nodes, :data, :root_name

    def initialize
      @nodes = {}
      # @cache_key = false
    end

    def each(&block)
      @nodes.each &block
    end

    # def initialize_dup(other)
    # super
    # self.nodes = other.nodes.dup
    # end

    def add(n)
      if n[:attr] && n[:name] != n[:attr]
        n[:name] = "#{n[:name]}(#{n[:attr]})"
      end

      @nodes[n[:name]] = Node.new(n[:name], n[:attr], n[:nested])
    end

    def extends(template)
      @nodes.merge! template.nodes
    end

  end
  # Class that will compile RABL source code into a hash
  # representing data structure
  class RablCompiler

    def initialize(file_path, view_path: 'app/views')
      paths = Dir["#{view_path}/#{file_path}{.json,}.rabl"]
      file_path = paths.find { |path| File.exist?(path) }

      @source = _preserve_ivars File.read(file_path)
    rescue
    end

    # find all instance variables used and prepend them with ':' to
    # turn into symbols on compile. otherwise they turn to nil(random ivar is nil)
    def _preserve_ivars(source)
      source.gsub /(@[^\s]*)/, ':\1'
    end

    # Compile from source code and return the CompiledAttributes created.
    def compile_source
      return unless @source
      @attributes = CompiledAttributes.new
      instance_eval(@source)
      @attributes
    end

    #
    # Sets the object to be used as the data for the template
    # Example:
    #   object :@user
    #   object :@user, :root => :author
    #
    # dont care about object / collection options. need only attributes
    def object(a)
      @attributes.data = a
    end
    alias collection object

    #
    # Includes the attribute or method in the output
    # Example:
    #   attributes :id, :name
    #   attribute :email => :super_secret
    #
    # save attribute to nodes
    def attribute(*args)
      if args.first.is_a?(Hash)
        args.first.each_pair do |key, name|
          @attributes.add(name: name, attr: key)
        end
      else
        options = args.extract_options!
        args.each do |name|
          key = options[:as] || name
          @attributes.add(name: name, attr: key)
        end
      end
    end
    alias attributes attribute

    #
    # Creates a child node to be included in the output.
    # name_or data can be an object or collection or a method to call on the data. It
    # accepts :root and :partial options.
    # Notes that partial and blocks are not compatible
    # Example:
    #   child(:@posts, :root => :posts) { attribute :id }
    #   child(:posts, :partial => 'posts/base')
    #   child(:@posts => :cool_posts, :root => :posts) { attribute :id }
    #
    def child(name_or_data, options = {})
      data, name = extract_data_and_name(name_or_data)

      if options.empty? && name_or_data.is_a?(Hash) && new_options = name_or_data.to_a.second
        options = [new_options].to_h
      end

      name = options[:root] if options.key? :root

      if options.key?(:partial)
        attrs = RablCompiler.new(options[:partial]).compile_source
      elsif block_given?
        attrs = sub_compile(data) { yield }
      end

      @attributes.add(name: name, attr: data, nested: attrs.nodes)
    end

    #
    # Glues data from a child node to the output
    # Example:
    #   glue(:@user) { attribute :name }
    #
    def glue(data)
      return unless block_given?

      template = sub_compile(data) { yield }

      template.nodes.each_value do |value|
        @attributes.add name: value.name, attr: "#{data}.#{value.attr}", nested: value.nested
      end
    end

    #
    # Creates an arbitrary node in the json output.
    # It accepts :if option to create conditionnal nodes. The current data will
    # be passed to the block so it is advised to use it instead of ivars.
    # Example:
    #   node(:name) { |user| user.first_name + user.last_name }
    #   node(:role, if: ->(u) { !u.admin? }) { |u| u.role }
    #
    def node(name = nil, _options = {})
      return unless block_given?
      @attributes.add name: name
    end
    alias code node

    #
    # Merge arbitrary data into json output. Given block should
    # return a hash.
    # Example:
    #   merge { |item| partial("specific/#{item.to_s}", object: item) }
    #
    # def merge
      # return unless block_given?
      # yield
    # end

    #
    # Extends an existing rabl template
    # Example:
    #   extends 'users/base'
    #
    def extends(path)
      extended = RablCompiler.new(path).compile_source
      @attributes.extends extended
    end

    #
    # Provide a conditionnal block
    #
    # condition(->(u) { u.is_a?(Admin) }) do
    #   attributes :secret
    # end
    #
    # def condition(*)
      # return unless block_given?
      # template = sub_compile(nil, true) { yield }
      # @attributes.extends template
    # end
    #
    def method_missing(name, *attrs)
      return p("#{name} is not implemented in railsApiDoc") if name.in?(['merge', 'condtiion'])
      super
    end

    protected

    #
    # Extract data root_name and root name
    # Example:
    #   :@users -> [:@users, nil]
    #   :@users => :authors -> [:@users, :authors]
    #
    def extract_data_and_name(name_or_data)
      case name_or_data
      when Symbol
        str = name_or_data.to_s
        str.start_with?('@') ? [name_or_data, str[1..-1]] : [name_or_data, name_or_data]
      when Hash
        name_or_data.first
      else
        name_or_data
      end
    end

    def sub_compile(data, only_nodes = false)
      raise unless block_given?
      old_template = @attributes
      @attributes = CompiledAttributes.new
      yield
      @attributes.data = data
      only_nodes ? @attributes.nodes : @attributes
    ensure
      @attributes = old_template
    end

  end

end
