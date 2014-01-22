# encoding: utf-8

module SublimeSunippetter
  # TargetMethod. this is method information container
  class TargetMethod
    attr_accessor :method_name, :args, :has_do_block, :has_brace_block

    # generate sublime text2 sunippets from Sunippetdefine
    def initialize(&block)
      instance_eval do
        block.call(self)
      end
    end
  end
end
