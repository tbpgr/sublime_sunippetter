# SublimeSunippetter

SublimeSunippetter is generate Sublime Text2 simple sunippet from Sunippetfile DSL.

## Installation

Add this line to your application's Gemfile:

    gem 'sublime_sunippetter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sublime_sunippetter

## Usage
### Generate
First, you create Sunippetfile manually or following command.

    suni init

Second, you have to edit Sunippetfile. 

    # encoding: utf-8

    # set output path. default=current directory
    output_path 'C:/Users/user_name/AppData/Roaming/Sublime Text 2/Packages/User'

    # set sunippet scope. default=source.ruby
    scope "source.ruby"

    # if two args method
    add :hoge, :args1, :args2
    # if no args method
    add :hige

Third, you have to do is execute command suni.

    suni

Result => generate hoge.sublime-snippet, hige.sublime-snippet

This Sample Sunppet Contens are ...

    <snippet>
      <content><![CDATA[
    hoge ${1:args1}, ${2:args2}
    ]]></content>
      <tabTrigger>hoge</tabTrigger>
      <scope>source.ruby</scope>
      <description>hoge method</description>
    </snippet>

And

    <snippet>
      <content><![CDATA[
    hige
    ]]></content>
      <tabTrigger>hige</tabTrigger>
      <scope>source.ruby</scope>
      <description>hige method</description>
    </snippet>

in 'C:/Users/user_name/AppData/Roaming/Sublime Text 2/Packages/User' directory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
