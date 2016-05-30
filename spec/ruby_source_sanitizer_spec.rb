require 'spec_helper'

class MySanitizer < RubySourceSanitizer
  permit(:block)
  permit(:defn)
  permit(:call)
  permit(:args)
  permit(:return)
  permit(:str)

  def rewrite_call(exp)
    return nil unless [:visit, :root_path].include?(exp[2])
    exp
  end
end

describe RubySourceSanitizer do
  it 'has a version number' do
    expect(RubySourceSanitizer::VERSION).not_to be nil
  end

  it 'sanitizes ruby source code' do
    code = <<-RUBY
      def test(a)
        return "foo"
      end

      visit root_path
      click "Button"
    RUBY

    result = MySanitizer.new.sanitize(code)
    #p result
    expect(result).to include("test")
    expect(result).to_not include("click")
  end
end
