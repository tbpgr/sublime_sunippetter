# encoding: utf-8
require 'sublime_sunippetter/version'
require 'erb'
require 'sublime_sunippetter_dsl'
require 'sublime_sunipetter_templates'

module SublimeSunippetter
  # SublimeSunippetter Core
  class Core
    # Sunippetdefine file name.
    DEFINE_FILE = 'Sunippetdefine'

    # generate Sunippetdefine to current directory.
    def init
      File.open("./#{DEFINE_FILE}", 'w') do |f|
        f.puts SublimeSunippetter::Templates::DEFINE_FILE_TEMPLATE
      end
    end

    # generate sublime text2 sunippets from Sunippetdefine
    def generate_sunippets
      sunippet_define = read_sunippetdefine
      dsl = Dsl.new
      dsl.instance_eval sunippet_define
      output_methods(dsl)
      output_requires(dsl)
    end

    private

    def read_sunippetdefine
      unless File.exist? "./#{DEFINE_FILE}"
        fail SunippetterError, "you must create #{DEFINE_FILE}. manual or 'suni init' command" # rubocop:disable LineLength
      end
      File.read("./#{DEFINE_FILE}")
    end

    def get_snippet(method_name, args_names, do_block, brace_block, scope)
      ERB.new(SublimeSunippetter::Templates::SUNIPPET_TEMPLATE).result(binding)
    end

    def get_args_names(method)
      args = method.args
      args_names = ' '
      args.each_with_index { |a, i|args_names << "${#{i + 1}:#{a}}, " }
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

    def get_require_snippet(require_file, scope)
      ERB.new(SublimeSunippetter::Templates::REQUIRE_SUNIPPET_TEMPLATE).result(binding) # rubocop:disable LineLength
    end

    def output_methods(dsl)
      dsl.target_methods.each do |m|
        snippet = get_snippet(
          m.method_name ,
          get_args_names(m) ,
          get_do_block(m).chop,
          get_brace_block(m),
          dsl.scope_value
        )
        File.open(method_file_path(dsl, m), 'w:UTF-8') { |f|f.puts snippet }
      end
    end

    def method_file_path(dsl, method)
      basename = "#{dsl.output_path_value}/#{method.method_name.to_s.tr('?', '')}" # rubocop:disable LineLength
      "#{basename}.sublime-snippet"
    end

    def output_requires(dsl)
      dsl.requires.each do |r|
        require_snippet = get_require_snippet(r, dsl.scope_value)
        File.open("require_#{r}.sublime-snippet", 'w:UTF-8') do |f|
          f.puts require_snippet
        end
      end
    end
  end

  class SunippetterError < StandardError; end
end
