# encoding: utf-8
require 'sublime_sunippetter/version'
require 'erb'
require 'sublime_sunippetter_dsl'

module SublimeSunippetter
  # SublimeSunippetter Core
  class Core
    # Sunippetdefine file name.
    DEFINE_FILE = 'Sunippetdefine'

    # Sunippetdefine file template
    DEFINE_FILE_TEMPLATE = <<-EOS
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

    # sublime sunippet template
    SUNIPPET_TEMPLATE = <<-EOS
<snippet>
  <content><![CDATA[
<%= method_name %><%= args_names %><%= do_block %><%= brace_block %>
]]></content>
  <tabTrigger><%= method_name %></tabTrigger>
  <scope><%= scope%></scope>
  <description><%= method_name %> method</description>
</snippet>
    EOS

    # generate Sunippetdefine to current directory.
    def init
      File.open("./#{DEFINE_FILE}", 'w') { |f|f.puts DEFINE_FILE_TEMPLATE }
    end

    # generate sublime text2 sunippets from Sunippetdefine
    def generate_sunippets
      sunippet_define = read_sunippetdefine
      dsl = Dsl.new
      dsl.instance_eval sunippet_define
      dsl.target_methods.each do |m|
        snippet = get_snippet(
          m.method_name ,
          get_args_names(m) ,
          get_do_block(m).chop,
          get_brace_block(m),
          dsl._scope
        )
        filename = "#{dsl._output_path}/#{m.method_name.to_s.tr('?', '')}.sublime-snippet"
        File.open(filename, 'w:UTF-8') { |f|f.puts snippet }
      end
    end

    private
    def read_sunippetdefine
      unless File.exists? "./#{DEFINE_FILE}"
        fail SunippetterError, "you must create #{DEFINE_FILE}. manual or 'suni init' command"
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
      args_names = ' '
      args.each_with_index do |a, i|
        args_names << "${#{i + 1}:#{a}}, "
      end
      args_names.chop!.chop! unless args.empty?
    end

    def get_do_block(method)
      return '' unless method.has_do_block
      <<-EOS
 do |${9:args}|
  ${0:block}
end
      EOS
    end

    def get_brace_block(method)
      return '' unless method.has_brace_block
      ' { |${9:args}|${0:block} }'
    end
  end

  class SunippetterError < StandardError; end
end
