# encoding: utf-8
require_relative '../lib/sublime_sunippetter'
require 'spec_helper'

# rubocop:disable LineLength
describe SublimeSunippetter::Core do
  cases_init = [
    {
      case_no: 1,
      expected: SublimeSunippetter::Templates::DEFINE_FILE_TEMPLATE
    }
  ]

  cases_init.each do |c|
    it "#init case_no=#{c[:case_no]} generate #{SublimeSunippetter::Core::DEFINE_FILE}" do
      # given
      sunippet = SublimeSunippetter::Core.new

      # when
      sunippet.init

      # then
      actual = File.read("#{SublimeSunippetter::Core::DEFINE_FILE}")
      expect(actual).to eq(c[:expected])
    end
  end

  GENERATE_SUNIPPETS_CASE = <<-EOS
output_path "#{File.absolute_path('.')}"
scope "source.java"
add :hoge, :args1, :args2
add :hige?
add :hoge1, "block@b"
add :hoge2, "block@d"
add :hoge3, :args1, :args2, "block@b"
add_requires 'hoge', 'hige'
  EOS

  cases_generate_sunippets = [
    {
      case_no: 1,
      sunippetdefine: GENERATE_SUNIPPETS_CASE,
      output_file_names: [
        'hoge.sublime-snippet',
        'hige.sublime-snippet',
        'hoge1.sublime-snippet',
        'hoge2.sublime-snippet',
        'hoge3.sublime-snippet',
        'require_hoge.sublime-snippet',
        'require_hige.sublime-snippet'
      ]
    }
  ]

  context do
    before do
      File.open("./#{SublimeSunippetter::Core::DEFINE_FILE}", 'w') { |f|f.puts GENERATE_SUNIPPETS_CASE }
    end

    cases_generate_sunippets.each do |c|

      it "#generate_sunippets case_no=#{c[:case_no]}" do
        # given
        sunippet = SublimeSunippetter::Core.new

        # when
        sunippet.generate_sunippets

        # then
        c[:output_file_names].each do |f|
          FileTest.exist?("./#{f}").should be_true
          File.delete("./#{f}")
        end
      end
    end
  end

  after(:each) do
    File.delete("#{SublimeSunippetter::Core::DEFINE_FILE}") if File.exist?("#{SublimeSunippetter::Core::DEFINE_FILE}")
  end
end
# rubocop:enable LineLength
