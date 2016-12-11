# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
# :nodoc:
module RailsApiDoc::Controller::Repo

  attr_accessor :repo

  def self.extended(base)
    base.instance_eval do
      @repo = Hash.new do |hsh, key|
        hsh[key] = Hash.new do |hsh, key|
          hsh[key] = RailsApiDoc::Controller::Request::Param.new(key, {})
        end
      end
    end
  end

  def method_missing(name, *args, &block)
    return @repo.send(name, *args, &block) if respond_to_missing?(name)
    super
  end

  def respond_to_missing?(method, *)
    @repo.respond_to?(method)
  end

  def []=(key, value)
    unless key < ActionController::Base
      raise ArgumentError, 'Repository keys are controllers only'
    end

    super
  end

end
