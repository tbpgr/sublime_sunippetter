# encoding: utf-8
require 'target_method'

module SublimeSunippetter
  # Dsl. this is dsl for Sunippetdefine.
  class Dsl
    attr_accessor :target_methods, :scope_value, :output_path_value, :requires

    # init default values
    def initialize
      @target_methods = []
      @scope_value = 'source.ruby'
      @output_path_value = './'
      @requires = []
    end

    # add sunippet information
    def add(method_name, *args)
      return if error?(method_name, *args)
      has_do_block = args.include?('block@d')
      has_brace_block = args.include?('block@b')
      args = delete_block_args args
      @target_methods << TargetMethod.new do |t|
        t.method_name = method_name
        t.args = args
        t.has_do_block = has_do_block
        t.has_brace_block = has_brace_block
      end
    end

    def add_requires(*filenames)
      @requires = filenames
    end

    # set sunippet scope
    def scope(value)
      return if value.nil?
      return if value.empty?
      @scope_value = value
    end

    # set sunippet output path
    def output_path(value)
      return if value.nil?
      return if value.empty?
      @output_path_value = value
    end

    private

    def error?(method_name, *args)
      return true if method_name.nil?
      return true if method_name.empty?
      return true if args.each.include?(nil)
      return true if args.each.include?('')
      false
    end

    def delete_block_args(args)
      args - ['block@b', 'block@d']
    end
  end

  class SunippetterError < StandardError; end
end
