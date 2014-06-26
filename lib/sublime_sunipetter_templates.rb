# encoding: utf-8

module SublimeSunippetter
  # SublimeSunippetter Core
  module Templates
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

# require snippet
# add_requires 'file1', 'file2'
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

    # sublime sunippet require template
    REQUIRE_SUNIPPET_TEMPLATE = <<-EOS
<snippet>
  <content><![CDATA[
require '<%= require_file %>'
]]></content>
  <tabTrigger>require <%= require_file %></tabTrigger>
  <scope><%= scope%></scope>
  <description>require <%= require_file %></description>
</snippet>
    EOS
  end
end
