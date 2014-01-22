require "sublime_sunippetter/version"
require "erb"

module SublimeSunippetter
  #= SublimeSunippetter Core
  class Core
    #== Sunippetdefine file name.
    DEFINE_FILE = "Sunippetdefine"

    #== Sunippetdefine file template
    DEFINE_FILE_TEMPLATE =<<-EOS
# encoding: utf-8

# set output path. default=current directory
# output_path 'C:/Users/user_name/AppData/Roaming/Sublime Text 2/Packages/User'

# set sunippet scope. default=source.ruby
# scope "source.ruby"

# if two args method
# add :hoge, :args1, :args2
# if no args method
# add :hige
# if two args method and do-block
# add :hoge1, :args1, :args2, "block@d"
# if two args method and brace-block
# add :hoge2, :args1, :args2, "block@b"
    EOS

    #== sublime sunippet template
    SUNIPPET_TEMPLATE =<<-EOS
<snippet>
  <content><![CDATA[
<%= method_name %><%= args_names %><%= do_block %><%= brace_block %>
]]></content>
  <tabTrigger><%= method_name %></tabTrigger>
  <scope><%= scope%></scope>
  <description><%= method_name %> method</description>
</snippet>
    EOS

    #== generate Sunippetdefine to current directory.
    def init
      File.open("./#{DEFINE_FILE}", "w") {|f|f.puts DEFINE_FILE_TEMPLATE}
    end

    #== generate sublime text2 sunippets from Sunippetdefine
    def generate_sunippets
      sunippet_define = read_sunippetdefine
      dsl = Dsl.new
      dsl.instance_eval sunippet_define
      dsl.target_methods.each do |m|
        snippet = get_snippet(m.method_name , get_args_names(m) , get_do_block(m).chop, get_brace_block(m), dsl._scope)
        File.open("#{dsl._output_path}/#{m.method_name.to_s.tr('?', '')}.sublime-snippet", "w:UTF-8") {|f|f.puts snippet}
      end
    end

    private
    def read_sunippetdefine
      unless File.exists? "./#{DEFINE_FILE}"
        raise SunippetterError.new("you must create #{DEFINE_FILE}. manual or 'suni init' command")
      end
      File.read("./#{DEFINE_FILE}")
    end

    def get_snippet(method_name, args_names, do_block, brace_block, scope)
      erb = ERB.new(SUNIPPET_TEMPLATE)
      snippet = erb.result(binding)
      snippet
    end

    def get_args_names(_method)
      args = _method.args
      args_names = " "
      args.each_with_index do |a, i|
         args_names << "${#{i + 1}:#{a}}, "
      end
      args_names.chop!.chop! unless args.empty?
    end

    def get_do_block(method)
      return "" unless method.has_do_block
      return <<-EOS
 do |${9:args}|
  ${0:block}
end
      EOS
    end

    def get_brace_block(method)
      return "" unless method.has_brace_block
      " { |${9:args}|${0:block} }"
    end
  end

  #= TargetMethod. this is method information container
  class TargetMethod
    attr_accessor :method_name, :args, :has_do_block, :has_brace_block

    #== generate sublime text2 sunippets from Sunippetdefine
    def initialize(&block)
      instance_eval do
        block.call(self)
      end
    end
  end

  #= Dsl. this is dsl for Sunippetdefine.
  class Dsl
    attr_accessor :target_methods, :_scope, :_output_path

    #== init default values
    def initialize
      @target_methods = []
      @_scope = "source.ruby"
      @_output_path = "./"
    end

    #== add sunippet information
    def add(method_name, *args)
      return if method_name.nil?
      return if method_name.empty?
      return if args.each.include?(nil)
      return if args.each.include?("")
      has_do_block = args.include?("block@d")
      has_brace_block = args.include?("block@b")
      args = delete_block_args args
      @target_methods << TargetMethod.new do |t|
        t.method_name = method_name
        t.args = args
        t.has_do_block = has_do_block
        t.has_brace_block = has_brace_block
      end
    end

    #== set sunippet scope
    def scope(_scope)
      return if _scope.nil?
      return if _scope.empty?
      @_scope = _scope
    end

    #== set sunippet output path
    def output_path(_output_path)
      return if _output_path.nil?
      return if _output_path.empty?
      @_output_path = _output_path
    end

    private

    def delete_block_args(args)
      args - ["block@b", "block@d"]
    end
  end

  class SunippetterError < StandardError;end
end
