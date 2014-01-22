# encoding: utf-8
require 'target_method'

module SublimeSunippetter
  # Dsl. this is dsl for Sunippetdefine.
  class Dsl
    attr_accessor :target_methods, :_scope, :_output_path

    # init default values
    def initialize
      @target_methods = []
      @_scope = 'source.ruby'
      @_output_path = './'
    end

    # add sunippet information
    def add(method_name, *args)
      return if method_name.nil?
      return if method_name.empty?
      return if args.each.include?(nil)
      return if args.each.include?('')
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

    # set sunippet scope
    def scope(_scope)
      return if _scope.nil?
      return if _scope.empty?
      @_scope = _scope
    end

    # set sunippet output path
    def output_path(_output_path)
      return if _output_path.nil?
      return if _output_path.empty?
      @_output_path = _output_path
    end

    private

    def delete_block_args(args)
      args - ['block@b', 'block@d']
    end
  end

  class SunippetterError < StandardError; end
end
