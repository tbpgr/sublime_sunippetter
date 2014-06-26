# encoding: utf-8
require_relative '../lib/sublime_sunippetter'
require 'spec_helper'
require 'target_method'

describe SublimeSunippetter::Dsl do
  cases_add = [
    {
      case_no: 1,
      method_names: :hoge,
      params: [:hoge, :hige, :hage],
      expecteds: SublimeSunippetter::TargetMethod.new do |t|
        t.method_name = :hoge
        t.args = [:hoge, :hige, :hage]
      end
    },
    {
      case_no: 2,
      method_names: nil,
      params: [:hoge, :hige, :hage],
      expecteds: nil,
      invalid?: true
    },
    {
      case_no: 3,
      method_names: '',
      params: [:hoge, :hige, :hage],
      expecteds: '',
      invalid?: true
    },
    {
      case_no: 4,
      method_names: :hoge,
      params: [:hoge, nil, :hage],
      expecteds: '',
      invalid?: true
    },
    {
      case_no: 5,
      method_names: :hoge,
      params: [:hoge, '', :hage],
      expecteds: '',
      invalid?: true
    },
  ]

  cases_add.each do |c|
    it "#add case_no=#{c[:case_no]} add method_names=#{c[:method_names]}, params=#{c[:params]}" do
      # given
      dsl = SublimeSunippetter::Dsl.new

      # when
      if c[:params].nil?
        dsl.add c[:method_names]
      else
        dsl.add c[:method_names], *c[:params]
      end
      actual = dsl.target_methods.first

      # then
      if c[:invalid?]
        expect(actual).to be nil
      else
        expect(actual.method_name).to eq(c[:expecteds].method_name)
        expect(actual.args).to eq(c[:expecteds].args)
      end
    end
  end

  cases_add_requires = [
    {
      case_no: 1,
      require_files: %w(hoge hige),
      expecteds: %w(hoge hige)
    },
  ]

  cases_add_requires.each do |c|
    it "#add_requires case_no=#{c[:case_no]} add require_files=#{c[:require_files]}" do
      # given
      dsl = SublimeSunippetter::Dsl.new

      # when
      dsl.add_requires c[:require_files][0], c[:require_files][1]
      actual = dsl.requires

      # then
      expect(actual).to eq(c[:expecteds])
    end
  end

  cases_scope = [
    {
      case_no: 1,
      scope: 'source.java',
      expected: 'source.java'
    },
    {
      case_no: 2,
      scope: nil,
      expected: 'source.ruby'
    },
    {
      case_no: 3,
      scope: '',
      expected: 'source.ruby'
    },
  ]

  cases_scope.each do |c|
    it "#scope case_no=#{c[:case_no]} add scope=#{c[:scope]}" do
      # given
      dsl = SublimeSunippetter::Dsl.new

      # when
      dsl.scope c[:scope]

      # then
      expect(dsl._scope).to eq(c[:expected])
    end
  end

  cases_output_path = [
    {
      case_no: 1,
      output_path: 'C:\\',
      expected: 'C:\\'
    },
    {
      case_no: 2,
      output_path: nil,
      expected: './'
    },
    {
      case_no: 3,
      output_path: '',
      expected: './'
    },
  ]

  cases_output_path.each do |c|
    it "#output_path case_no=#{c[:case_no]} add output_path=#{c[:output_path]}" do
      # given
      dsl = SublimeSunippetter::Dsl.new

      # when
      dsl.output_path c[:output_path]

      # then
      expect(dsl._output_path).to eq(c[:expected])
    end
  end
end
